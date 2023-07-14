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
	"yana/yana"

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
type PMessage struct {
	pId         int32
	username    string
	title       string
	media_url   string
	location    string
	description string
	Time        string
}

type UserData struct {
	id        int32
	user      string
	email     string
	media_url string
	bio       string
	location  string
	//friends 	string

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
	row := db.QueryRow("SELECT * FROM users WHERE name=$1", user)
	var usr string
	err := row.Scan(&usr)
	if err == sql.ErrNoRows {
		fmt.Println("something wrong while trynna login", err)
		return false
	}
	//log.Println("I correctly find a user ")
	return true
}

func getUsers() ([]*yana.UserData) {
	udata_list := make([]*yana.UserData, 0)
	log.Println("I am at getUsers ")
	//users := make([]string, 0)
	rows, err := db.Query("SELECT Name, COALESCE(email,' '), COALESCE(media_url, ' '), COALESCE(location, ' '), COALESCE(bio,'')  FROM users;")
	defer rows.Close()
	if err != nil {
		fmt.Println("error while querying users", err)

	} else {
		for rows.Next() {
			umsg := UserData{}
			res := yana.UserData{}
			//var usr sql.NullString
			//var pswd sql.NullString
			err := rows.Scan(&umsg.user, &umsg.email, &umsg.media_url, &umsg.location, &umsg.bio)
			if err != nil {
				fmt.Println(err)
				fmt.Println("user -> : ", umsg.user)
				break
			}
			//fmt.Println("user -> : ", usr.String)
			res.Name = umsg.user
			res.Email = umsg.email
			res.MediaUrl = umsg.media_url
			res.Location = umsg.location
			res.Bio = umsg.bio
			udata_list = append(udata_list, &res)

		}
	}
	log.Println("I did get users correctly")
	return udata_list
}

func verifyPassword(username string, password string) bool {
	row := db.QueryRow("SELECT Name, Password FROM users WHERE name=$1", username)
	var user_password string
	var user_name string
	err := row.Scan(&user_name, &user_password)
	if err == sql.ErrNoRows || err != nil {
		fmt.Println("error at query passowrd #verfiyPassword# ")
		return false
	}

	if password == user_password {
		return true
	} else {
		return false
	}
	return false

}

func getMessages(user string) []*yana.Result {
	//log.Println("i am a get messages ")
	messages := make([]*yana.Result, 0)
	rows, err := db.Query("SELECT * FROM messages WHERE  Sender =$1 or Receiver =$1", user)
	defer rows.Close()
	if err != nil {
		fmt.Println(err)
	} else {
		for rows.Next() {
			msg := Message{}
			res := yana.Result{}
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

func insertMessages(sender string, receiver string, message string, t time.Time) (bool, yana.Result) {
	//log.Println("I am at insert messages")

	row := db.QueryRow("INSERT INTO messages(Sender,Receiver,Body,Sent) VALUES($1,$2,$3,$4) RETURNING *;", sender, receiver, message, t)
	var msg Message = Message{}
	var res = yana.Result{}
	err := row.Scan(&msg.Sender, &msg.Receiver, &msg.Message, &msg.Time)
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

func getPosts(user string) []*yana.PostResult {

	posts := make([]*yana.PostResult, 0)
	rows, err := db.Query("SELECT Username, Location, Description, PostedAt, COALESCE(title,' '), COALESCE(Media_url,' ') FROM posts WHERE Username = $1", user)
	defer rows.Close()
	if err != nil {
		fmt.Println(err)

	} else {
		for rows.Next() {
			pmsg := PMessage{}
			res := yana.PostResult{}
			err := rows.Scan(&pmsg.username, &pmsg.location, &pmsg.description, &pmsg.Time, &pmsg.title, &pmsg.media_url)
			if err != nil {
				fmt.Println(err)
				break
			}

			res.Id = pmsg.pId
			res.Name = pmsg.username
			res.Title = pmsg.title
			res.MediaUrl = pmsg.media_url
			res.Location = pmsg.location
			res.Description = pmsg.description
			res.Time = pmsg.Time
			//log.Println(res.Location)
			posts = append(posts, &res)
		}

	}
	log.Println(posts[0].Location)
	return posts
}

func insertPost(user string, title string, media_url string, location string, description string, t time.Time) (bool, yana.PostResult) {
	fmt.Println("I am at insert posts ")
	row := db.QueryRow("INSERT INTO posts(UserName, Title, media_url, Location, Description, PostedAt) VALUES($1,$2,$3,$4,$5,$6) RETURNING *;", user, title, media_url, location, description, t)
	var msg PMessage = PMessage{}
	var res = yana.PostResult{}

	err := row.Scan(&msg.username, &msg.title, &msg.media_url, &msg.location, &msg.description, &msg.Time)
	if err == sql.ErrNoRows {
		fmt.Println("something bad happened at insert post ")
		return false, res
	}
	res.Id = msg.pId
	res.Name = msg.username
	res.Title = msg.title
	res.MediaUrl = msg.media_url
	res.Location = msg.location
	res.Description = msg.description
	res.Time = msg.Time
	fmt.Println("insert post work just fine ")

	return true, res
}

func insertUser(user string, password string) bool {
	_, err := db.Exec("INSERT INTO users(Name,Password) VALUES($1,$2) RETURNING *;", user, password)
	return checkError(err)

}
func insertUserData(user string, email string, media_url string, location string) bool {

	_, err := db.Exec("INSERT INTO users(Email, Media_url, Location) VALUES($3,$4,$5) WHERE UserName=$1 RETURNING*;", email, media_url, location, user)
	if err == sql.ErrNoRows {
		return false
	}
	return true
}
func getUserData(user string) (bool, yana.UserData) {

	var udata = yana.UserData{}
	fmt.Println("hi I am getUserData")

	row := db.QueryRow("SELECT Name, COALESCE(email, ' '), COALESCE(media_url,' '), COALESCE(location,' '), COALESCE(bio,' ') FROM users WHERE name = $1", user)
	//defer row.Close()
	umsg := UserData{}
	fmt.Println("at getUserData things are okay")
	err := row.Scan(&umsg.user, &umsg.email, &umsg.media_url, &umsg.location, &umsg.bio)
	if err == sql.ErrNoRows {
		fmt.Println(err)
		return false, udata
	}
	udata.Name = umsg.user
	udata.Email = umsg.email
	udata.MediaUrl = umsg.media_url
	udata.Location = umsg.location
	udata.Bio = umsg.bio

	return true, udata
}

func checkError(err error) bool {
	if err != nil {
		fmt.Println("error : ", err)
		return true
	}
	return false
}

func (s server) UpdateUser(ctx context.Context, req *yana.UpdateRequest) (*yana.UpdateResponse, error){
	data := req.GetData()
	_, user_data := getUserData(data.Name)
	return &yana.UpdateResponse{Response: &yana.Response{Status:http.StatusBadRequest, Message: "unimplemented "}, Data: &user_data},nil
}


//###########################################################################################################
//###########################################################################################################
func (s server) Register(ctx context.Context, req *yana.RegisterRequest) (*yana.RegisterResponse, error) {
	name := req.GetUsername()
	password := req.GetPassword()

	if len(name) == 0 {
		return &yana.RegisterResponse{Response: &yana.Response{Status: http.StatusBadRequest, Message: "name field is empty "}}, nil
	}
	mu.Lock()
	defer mu.Unlock()

	exists := find(name)
	if exists {
		return &yana.RegisterResponse{Response: &yana.Response{Status: http.StatusBadRequest, Message: "username already exist try different name "}}, nil

	}
	added := insertUser(name, password)
	if !added {
		return &yana.RegisterResponse{Response: &yana.Response{Status: http.StatusBadRequest, Message: "Unable to insert user or password in DB"}}, nil

	}

	return &yana.RegisterResponse{Response: &yana.Response{Status: http.StatusOK, Message: " Success"}}, nil
}

func (s server) Login(ctx context.Context, req *yana.LoginRequest) (*yana.LoginResponse, error) {

	username := req.GetUsername()
	password := req.GetPassword()
	//token :=  req.GetToken()

	mu.Lock()
	defer mu.Unlock()
	user_exists := find(username)
	log.Println(username)
	pass_verified := verifyPassword(username, password)

	status, user_data := getUserData(username)
	fmt.Println("Heyyyyyy")

	if user_exists == false {
		fmt.Println("user name was not found #login# ")
		return &yana.LoginResponse{Response: &yana.Response{Status: http.StatusBadRequest, Message: "username does exists"}}, nil

	}
	if pass_verified == false {
		fmt.Println("user password was not found #login# ")
		return &yana.LoginResponse{Response: &yana.Response{Status: http.StatusBadRequest, Message: "password verification failed "}}, nil
	}
	if status == false {
		fmt.Println("status false")
	}
	fmt.Println("things seems to work ###")
	return &yana.LoginResponse{Response: &yana.Response{Status: http.StatusOK, Message: " Success password verification succeeded "}, Userdata: &user_data}, nil
}

//func (s server) ValidateToken(ctx context.Context, req *yana.ValidateTokenRequest)(*yana.ValidateTokenResponse, error){

//token := GetToken()
//}

func (s server) Users(ctx context.Context, req *yana.GetUser) (*yana.SendUser, error) {

	var users = getUsers()
	fmt.Println(users)
	return &yana.SendUser{Udata: users}, nil

}

func (s server) Message(ctx context.Context, req *yana.GetMessages) (*yana.SendMessages, error) {

	user := req.GetUser()
	if len(user) == 0 {
		return &yana.SendMessages{Response: &yana.Response{Status: http.StatusBadRequest, Message: "Name field is empty"}}, nil
	}
	exist := find(user)
	if !exist {
		return &yana.SendMessages{Response: &yana.Response{Status: http.StatusBadRequest, Message: "User doesn't exist"}}, nil
	}
	var messages = getMessages(user)
	return &yana.SendMessages{Response: &yana.Response{Status: http.StatusOK, Message: "get msgs Success"}, Message: messages}, nil
}

func (s server) GetPost(ctx context.Context, req *yana.GetPostRequest) (*yana.GetPostResponse, error) {

	user := req.GetUser()
	exist := find(user)
	if !exist {
		return &yana.GetPostResponse{Response: &yana.Response{Status: http.StatusBadRequest, Message: " user doesn't exist"}}, nil

	}
	var post_msgs = getPosts(user)
	fmt.Println(post_msgs)

	return &yana.GetPostResponse{Response: &yana.Response{Status: http.StatusOK, Message: "get post Success"}, Presult: post_msgs}, nil
}
func (s server) Post(ctx context.Context, req *yana.PostRequest) (*yana.PostResponse, error) {

	user := req.GetUsername()
	mu.Lock()
	defer mu.Unlock()
	user_exists := find(user)
	log.Println(user)

	if user_exists == true {

		username := req.GetUsername()
		description := req.GetDescription()
		location := req.GetLocation()
		title := req.GetTitle()
		media_url := req.GetMediaUrl()

		t := time.Now()

		inserted, _ := insertPost(username, title, media_url, description, location, t)

		if !inserted {
			return &yana.PostResponse{Response: &yana.Response{Status: http.StatusBadRequest, Message: "unable to add the msg to db"}}, nil

		}

		return &yana.PostResponse{Response: &yana.Response{Status: http.StatusOK, Message: " Success password verification succeeded "}}, nil

	}
	return &yana.PostResponse{Response: &yana.Response{Status: http.StatusBadRequest, Message: "username does exists"}}, nil

}

func (s server) Send(ctx context.Context, req *yana.SendRequest) (*yana.SendResponse, error) {

	from := req.GetFrom()
	to := req.GetTo()
	msg := req.GetMessage()
	//t := time.Now()

	if len(from) == 0 || len(to) == 0 || len(msg) == 0 {
		return &yana.SendResponse{Response: &yana.Response{Status: http.StatusBadRequest, Message: "Invalid Format"}}, nil

	}

	mu.Lock()
	defer mu.Unlock()

	usr1 := find(from)
	usr2 := find(to)

	if !usr1 || !usr2 {
		return &yana.SendResponse{Response: &yana.Response{Status: http.StatusBadRequest, Message: "user not found"}}, nil
	}

	t := time.Now()
	inserted, message := insertMessages(from, to, msg, t)
	if !inserted {
		return &yana.SendResponse{Response: &yana.Response{Status: http.StatusBadRequest, Message: "unable to add the msg to db"}}, nil

	}

	return &yana.SendResponse{Response: &yana.Response{Status: http.StatusOK, Message: "sent success"}, Result: &message}, nil
}

func main() {
	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", 50051))
	if err != nil {
		log.Fatalf("failed to listen : %v", err)
	}

	s := server{}
	grpc_server := grpc.NewServer()

	yana.RegisterChatServer(grpc_server, &s)
	fmt.Println("grpc server is running on port 64456")
	if err := grpc_server.Serve(lis); err != nil {
		log.Fatalf("failed to serve :%s", err)

	}
	defer db.Close()
}
