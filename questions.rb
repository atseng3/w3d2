require 'singleton'
require 'sqlite3'
require_relative './user'
require_relative './question'
require_relative './reply'
require_relative './question_followers'
require_relative './question_likes'

class QuestionDatabase < SQLite3::Database

  include Singleton

  def initialize
    super("questions.db")

    self.results_as_hash = true

    self.type_translation = true
  end
end
