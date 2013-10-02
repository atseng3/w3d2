class QuestionLike

  def self.likers_for_question_id(q_id)
    likers = QuestionDatabase.instance.execute(<<-SQL,q_id)
    SELECT users.*
    FROM users INNER JOIN question_likes ON liked_user_id = users.id
    WHERE question_id = ?
    SQL

    likers.map { |liker| User.new(liker) }
  end

  def self.num_likes_for_question_id(q_id)
    num_likes = QuestionDatabase.instance.execute(<<-SQL, q_id)
    SELECT COUNT(liked_user_id)
    FROM users INNER JOIN question_likes ON liked_user_id = users.id
    WHERE question_id = ?
    SQL
    num_likes.first.values.first
  end

  def self.liked_questions_for_user_id(u_id)
    questions = QuestionDatabase.instance.execute(<<-SQL, u_id)
    SELECT questions.*
    FROM questions INNER JOIN question_likes ON questions.id = question_id
    WHERE liked_user_id = ?
    SQL
    questions.map { |question| Question.new(question) }
  end

  def self.most_liked_questions(n)
    questions = QuestionDatabase.instance.execute(<<-SQL, n)
    SELECT questions.*
    FROM question_likes INNER JOIN questions ON question_id = questions.id
    GROUP BY question_id
    ORDER BY COUNT(question_id) DESC
    LIMIT 0, ?
    SQL

    questions.map { |question| Question.new(question) }
  end

  def self.average_karma(u_id)
    avg_likes = QuestionDatabase.instance.execute(<<-SQL, u_id).first.values.first
    SELECT AVG(count_of_likes.likes_per_question)
    FROM
    (
    SELECT question_id, COUNT(liked_user_id) AS likes_per_question
    FROM question_likes INNER JOIN
    (SELECT *
    FROM questions
    WHERE author_id = ?
    ) as my_ques
    ON question_id = my_ques.id
    GROUP BY my_ques.id
    ) AS count_of_likes
    SQL
    end

end