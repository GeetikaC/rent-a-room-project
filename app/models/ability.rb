class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    if user.nil?
        can :read, [Room, Amenity]
    elsif user.role? "admin"
        # Only admin should be able to add roles, cities and amenities.
        # admin will be able to manage all the rooms 
        can :manage, [Role, City, Amenity, Room]
    elsif user.role? "host"
        can [:create, :read], Room
        can :read, [Amenity, City]
        can [:create, :read, :update], Booking
        # Hosts should be able to update and destroy only their rooms
        can [:update, :destroy], Room do |room|
            room.user_id = user.id
        end
    elsif user.role? "guest"
        can [:create, :read], [Room, Booking]
        can :read, [Amenity, City]

    end 
  end
end
