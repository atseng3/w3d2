class QuestionFollowers

  def self.followers_for_question_id(id)
    followers = QuestionDatabase.instance.execute(<<-SQL, id)
    SELECT users.*
    FROM question_followers INNER JOIN users ON follower_id = users.id
    WHERE question_id = ?
    SQL
    followers.map { |follower_hash| User.new(follower_hash) }
  end

  def self.followed_questions_for_user_id(id)
    questions = QuestionDatabase.instance.execute(<<-SQL, id)
    SELECT questions.*
    FROM question_followers INNER JOIN questions ON question_id = questions.id
    WHERE follower_id = ?
    SQL
    questions.map { |question_hash| Question.new(question_hash) }
  end

  def self.most_followed_questions(n)
    questions = QuestionDatabase.instance.execute(<<-SQL, n)
    SELECT questions.*
    FROM question_followers JOIN questions ON question_id = questions.id
    GROUP BY question_id
    ORDER BY COUNT(follower_id) DESC
    LIMIT 0, ?
    SQL
    questions.map { |each_question| Question.new(each_question) }
  end

end