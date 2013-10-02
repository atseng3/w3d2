class Question
  attr_reader :id
  attr_accessor :title, :body, :author_id

  def self.find_by_id(id)
    question = QuestionDatabase.instance.execute(<<-SQL, id).first
    SELECT *
    FROM questions
    WHERE id = ?
    SQL
    Question.new(question)
  end

  def self.find_by_author_id(id)
    questions = QuestionDatabase.instance.execute(<<-SQL, id)
    SELECT *
    FROM questions
    WHERE author_id = ?
    SQL
    questions.map { |question| Question.new(question) }
  end

  def self.most_followed(n)
    QuestionFollowers.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def initialize(options = {})
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @author_id = options["author_id"]
  end

  def author
    author = QuestionDatabase.instance.execute(<<-SQL, @author_id).first
    SELECT *
    FROM users
    WHERE users.id = ?
    SQL
    User.new(author)
  end

  def replies
    Reply.find_by_question_id(self.id)
  end

  def followers
    QuestionFollowers.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

  def save
    if @id.nil?
      QuestionDatabase.instance.execute(<<-SQL, @title, @body, @author_id)
      INSERT INTO questions
      (title, body, author_id)
      VALUES
      (?, ?, ?);
      SQL

      @id = QuestionDatabase.instance.last_insert_row_id
    else
      QuestionDatabase.instance.execute(<<-SQL, @title, @body, @author_id, @id)
      UPDATE questions
      SET
      title = ?,
      body = ?,
      author_id = ?
      WHERE id = ?;
      SQL
    end
  end
end
