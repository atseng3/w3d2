class Reply
  attr_reader :reply_id
  attr_accessor :question_id, :parent_reply_id, :reply_author_id

  def self.find_by_id(id)
    reply = QuestionDatabase.instance.execute(<<-SQL, id).first
    SELECT *
    FROM replies
    WHERE reply_id = ?
    SQL

    Reply.new(reply)
  end

  def self.find_by_question_id(id)
    replies = QuestionDatabase.instance.execute(<<-SQL, id)
    SELECT *
    FROM replies
    WHERE replies.question_id = ?
    SQL
    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_user_id(id)
    replies = QuestionDatabase.instance.execute(<<-SQL, id)
    SELECT *
    FROM replies
    WHERE replies.reply_author_id = ?
    SQL
    replies.map { |reply| Reply.new(reply) }
  end

  def initialize(options = {})
    @reply_id = options["reply_id"]
    @question_id = options["question_id"]
    @content = options["content"]
    @parent_reply_id = options["parent_reply_id"]
    @reply_author_id = options["reply_author_id"]
  end

  def author
    author = QuestionDatabase.instance.execute(<<-SQL, @reply_author_id).first
    SELECT *
    FROM users
    WHERE users.id = ?
    SQL
    User.new(author)
  end

  def question
    question = QuestionDatabase.instance.execute(<<-SQL, @question_id).first
    SELECT *
    FROM questions
    WHERE id = ?
    SQL
    Question.new(question)
  end

  def parent_reply
    parent_r = QuestionDatabase.instance.execute(<<-SQL, @parent_reply_id).first
    SELECT *
    FROM replies
    WHERE reply_id = ?
    SQL
    Reply.new(parent_r)
  end

  def child_replies
    children = QuestionDatabase.instance.execute(<<-SQL, @reply_id)
    SELECT *
    FROM replies
    WHERE parent_reply_id = ?
    SQL

    children.map { |child_reply| Reply.new(child_reply) }
  end

  def save
    if @reply_id.nil?
      QuestionDatabase.instance.execute(<<-SQL, @question_id, @content, @parent_reply_id, @reply_author_id)
      INSERT INTO replies
      (question_id, content, parent_reply_id, reply_author_id)
      VALUES
      (?, ?, ?, ?);
      SQL

      @id = QuestionDatabase.instance.last_insert_row_id
    else
      QuestionDatabase.instance.execute(<<-SQL, @question_id, @content, @parent_reply_id, @reply_author_id, @reply_id)
      UPDATE replies
      SET
      question_id = ?,
      content = ?,
      parent_reply_id = ?,
      reply_author_id = ?
      WHERE reply_id = ?;
      SQL
    end
  end
end