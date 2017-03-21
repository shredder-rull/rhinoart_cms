class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || Rhinoart.user_class.new
    merge Rhinoart::Ability.new(@user)
  end
end