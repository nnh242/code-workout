# == Schema Information
#
# Table name: base_exercises
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  question_type      :integer
#  current_version    :integer
#  created_at         :datetime
#  updated_at         :datetime
#  versions           :integer
#  variation_group_id :integer
#

class BaseExercise < ActiveRecord::Base

  #~ Relationships ............................................................

  has_many :exercises
  belongs_to :variation_group
  belongs_to :user


  #~ Hooks ....................................................................

  before_validation :set_defaults


  #~ Validation ...............................................................

  validates :current_version, presence: true, numericality: true

  Q_MC     = 1
  Q_CODING = 2
  Q_BLANKS = 3

  TYPE_NAMES = {
    Q_MC     => 'Multiple Choice Question',
    Q_CODING => 'Coding Question',
    Q_BLANKS => 'Fill in the blanks'
  }


  #~ Public instance methods ..................................................

  def type_name
    TYPE_NAMES[self.question_type]
  end


  def is_mcq?
    self.question_type == Q_MC
  end


  def is_coding?
    self.question_type == Q_CODING
  end


  def is_fill_in_the_blanks?
    self.question_type == Q_BLANKS
  end


  def exercise
    ex = self.exercises.where(version: self.current_version).first
    if !ex
      ex = self.exercises(order: 'version DESC').first
    end
    return ex
  end


  #~ Private instance methods .................................................
  private

  def set_defaults
    self.question_type ||= Q_MC
  end


end
