package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"net"
	"net/http"
	"sync"
	"time"
	"yana/chat"

	_ "github.com/lib/pq"
	"google.golang.org/grpc"
)

var mu sync.Mutex

type server struct {
}

const (
	host     = "localhost"
	port     = 5432
	user     = "postgres"
	password = "Jeh891ni!"
	dbname   = "yana"
)

type Message struct {
	Id       int32
	Sender   string
	Receiver string
	Message  string
	Time     string
}

var db *sql.DB

func init() {
	var err error
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+"password=%s dbname=%s sslmode=disable", host, port, user, password, dbname)
	db, err = sql.Open("postgres", psqlInfo)
	checkError(err)
}

func find(user string) bool {
	//log.Println("I am at insert user ")
	row := db.QueryRow("SELECT * FROM users WHERE name = $1", user)
	var usr string
	err := row.Scan(&usr)
	if err == sql.ErrNoRows {
		return false
	}
	//log.Println("I correctly find a user ")
	return true
}

func getUsers() []string {
	log.Println("I am at getUsers ")
	users := make([]string, 0)
	rows, err := db.Query("SELECT * FROM users;")
	defer rows.Close()
	if err != nil {
		fmt.Println(err)

	} else {
		for rows.Next() {
			var usr string
			err := rows.Scan(&usr)
			if err != nil {
				fmt.Println(err)
				break
			}
			users = append(users, usr)

		}
	}
	log.Println("I did get users correctly")
	return users
}

func getMessages(user string) []*chat.Result {
	//log.Println("i am a get messages ")
	messages := make([]*chat.Result, 0)
	rows, err := db.Query("SELECT * FROM messages WHERE  Sender =$1 or Receiver =$1", user)
	defer rows.Close()
	if err != nil {
		fmt.Println(err)
	} else {
		for rows.Next() {
			msg := Message{}
			res := chat.Result{}
			//====================================================>msg.Message
			err := rows.Scan(&msg.Sender, &msg.Receiver, &msg.Message, &msg.Time)
			if err != nil {
				fmt.Println(err)
				break
			}

			res.Id = msg.Id
			res.From = msg.Sender
			res.To = msg.Receiver
			res.Message = msg.Message
			res.Time = msg.Time
			messages = append(messages, &res)
		}
	}
	//log.Println("got messages correctly")
	return messages

}

func insertMessages(sender string, receiver string, message string, t time.Time) (bool, chat.Result) {
	//log.Println("I am at insert messages")

	row := db.QueryRow("INSERT INTO messages(Sender,Receiver,Body,Sent) VALUES($1,$2,$3,$4) RETURNING *;", sender, receiver, message, t)
	var msg Message = Message{}
	var res = chat.Result{}
	err := row.Scan( &msg.Sender, &msg.Receiver, &msg.Message, &msg.Time)
	if err == sql.ErrNoRows {
		return false, res
	}
	res.Id = msg.Id
	res.From = msg.Sender
	res.To = msg.Receiver
	res.Message = msg.Message
	res.Time = msg.Time
	//log.Println("I am going to leave insert messages")
	return true, res

}

func insertUser(user string) bool {
	_, err := db.Exec("INSERT INTO users(name) values($1);", user)
	return checkError(err)

}

func checkError(err error) bool {
	if err != nil {
		fmt.Println("error : ", err)
		return true
	}
	return false
}

func (s server) Join(ctx context.Context, req *chat.JoinRequest) (*chat.JoinResponse, error) {
	name := req.GetName()
	if len(name) == 0 {
		return &chat.JoinResponse{Response: &chat.Response{Status: http.StatusBadRequest, Message: "name field is empty"}}, nil
	}
	mu.Lock()
	defer mu.Unlock()
	exists := find(name)
	if exists {
		return &chat.JoinResponse{Response: &chat.Response{Status: http.StatusBadRequest, Message: "Name already exists try different name "}}, nil
	}
	added := insertUser(name)
	if !added {
		return &chat.JoinResponse{Response: &chat.Response{Status: http.StatusBadRequest, Message: "Unable to insert user in DB"}}, nil
	}

	return &chat.JoinResponse{Response: &chat.Response{Status: http.StatusOK, Message: "Success"}}, nil
}

func (s server) Users(ctx context.Context, req *chat.GetUser) (*chat.SendUser, error) {

	var users = getUsers()

	return &chat.SendUser{User: users}, nil
}

func (s server) Message(ctx context.Context, req *chat.GetMessages) (*chat.SendMessages, error) {

	user := req.GetUser()
	if len(user) == 0 {
		return &chat.SendMessages{Response: &chat.Response{Status: http.StatusBadRequest, Message: "Name field is empty"}}, nil
	}
	exist := find(user)
	if !exist {
		return &chat.SendMessages{Response: &chat.Response{Status: http.StatusBadRequest, Message: "User doesn't exist"}}, nil
	}
	var messages = getMessages(user)
	return &chat.SendMessages{Response: &chat.Response{Status: http.StatusOK, Message: "get msgs Success"}, Message: messages}, nil
}

func (s server) Send(ctx context.Context, req *chat.SendRequest) (*chat.SendResponse, error) {
	from := req.GetFrom()
	to := req.GetTo()
	msg := req.GetMessage()

	if len(from) == 0 || len(to) == 0 || len(msg) == 0 {
		return &chat.SendResponse{Response: &chat.Response{Status: http.StatusBadRequest, Message: "Invalid Format"}}, nil
	}

	mu.Lock()
	defer mu.Unlock()

	usr1 := find(from)
	usr2 := find(to)

	if !usr1 || !usr2 {
		return &chat.SendResponse{Response: &chat.Response{Status: http.StatusBadRequest, Message: "User Not Found"}}, nil
	}
	t := time.Now()
	inserted, message := insertMessages(from, to, msg, t)
	if !inserted {
		return &chat.SendResponse{Response: &chat.Response{Status: http.StatusBadRequest, Message: "Error in inserting Message to DB"}}, nil
	}

	return &chat.SendResponse{Response: &chat.Response{Status: http.StatusOK, Message: "sent Sucess"}, Result: &message}, nil
}

func main() {

	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", 63456))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := server{}
	grpc_server := grpc.NewServer()

	chat.RegisterChatServer(grpc_server, &s)
	fmt.Println("grpc server is running on Port 63456")
	if err := grpc_server.Serve(lis); err != nil {
		log.Fatalf("failed to serve : %s", err)
	}
	defer db.Close()
}
