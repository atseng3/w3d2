class User
  attr_reader :id
  attr_accessor :fname, :lname

  def self.find_by_id(id)
    user = QuestionDatabase.instance.execute(<<-SQL, id).first
    SELECT *
    FROM users
    WHERE id = ?
    SQL
    User.new(user)
  end

  def self.find_by_name(fname, lname)
    user = QuestionDatabase.instance.execute(<<-SQL, fname, lname).first
    SELECT *
    FROM users
    WHERE fname = ?
    AND lname = ?
    SQL
    User.new(user)
  end

  def initialize(options = {})
    p options
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end

  def followed_questions
    QuestionFollowers.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    QuestionLike.average_karma(@id)
  end

  def save
    if @id.nil?
      QuestionDatabase.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO users
      (fname, lname)
      VALUES
      (?, ?);
      SQL

      @id = QuestionDatabase.instance.last_insert_row_id
    else
      QuestionDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
      UPDATE users
      SET
      fname = ?,
      lname = ?
      WHERE id = ?;
      SQL
    end
  end
end
