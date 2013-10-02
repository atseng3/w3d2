/*
# create users table with primary key (user id), fname, lname
id (for user)  fname   lname
1   albert  tseng
2   mainor  claros


#create questions table with title, body, user foreign key
id (for question)  title body      author_id
1   why?  why now?  1
2   how?  how is?   2
3		huh?  wha?			2


#create  question_followers table, follower_id, question_id
follower_id     questions_id
1               10
1               12
2               10

#create replies table reply_id, question_id, parent_reply_id , reply_author_id
reply_id  question_id   parent_reply_if  reply_author_id
1          2              null            1

#create question_likes table  liked_question_id, user_liking_id
title				liked_question_id  user_liking_id
huh?				3                      2
huh?				3											 3
huh?				3											 4
how?				2											 1
how?				2											 2
*/


CREATE TABLE users (
	id INTEGER PRIMARY KEY,
	fname VARCHAR(10) NOT NULL,
	lname VARCHAR(10) NOT NULL
);

CREATE TABLE questions (
	id INTEGER PRIMARY KEY,
	title VARCHAR(20),
	body VARCHAR(20),
	author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
	follower_id INTEGER,
	question_id INTEGER,

	FOREIGN KEY (follower_id) REFERENCES users(id),
	FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
	reply_id INTEGER PRIMARY KEY,
	question_id INTEGER,
	content VARCHAR(200),
	parent_reply_id INTEGER,
	reply_author_id INTEGER,

	FOREIGN KEY (parent_reply_id) REFERENCES replies(reply_id),
	FOREIGN KEY (question_id) REFERENCES questions(id),
	FOREIGN KEY (reply_author_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
	question_id INTEGER,
	liked_user_id INTEGER,

	FOREIGN KEY (question_id) REFERENCES questions(id),
	FOREIGN KEY (liked_user_id) REFERENCES users(id)
);




INSERT INTO
	users (fname, lname)
VALUES
	('Albert', 'Tseng'), ('Mainor', 'Claros'), ('Ryan', 'Patrick'), ('Ned', "Stark");

INSERT INTO
	questions (title, body, author_id)
VALUES
	('Why?', 'Why now?', 1), ('What is?', 'love?', 2), ("huh?", "wha?", 2);

INSERT INTO
	question_followers (follower_id, question_id)
VALUES
	(1, 1), (1, 2), (2, 1);

INSERT INTO
	replies (question_id, content, parent_reply_id, reply_author_id)
VALUES
	(1, "HAHA", NULL, 1), (1, "HEHE", 1, 2);

INSERT INTO
	question_likes (question_id, liked_user_id)
VALUES
	(1,1), (2,2), (2,1), (3, 3), (3, 4), (3, 2);