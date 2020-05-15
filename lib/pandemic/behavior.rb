module Pandemic
  class Behavior
    attr_accessor :travel, :contacts

    def initialize(contacts: CONTACTS, travel: TRAVEL)
      ### TRAVEL ###
      # Probably better thought of as an agent's social size,
      # travel limits how far an agent may contact another.
      # With a travel of (+/-)5, an agent has a social group of 120 contacts.
      # Probably also a variation parameter, and a prescription parameter.
      @travel = travel

      ### CONTACTS ###
      # Contacts number set to 100.0(conceptually 100% freely contacting agents)
      # Note though that it's an integer number of possible contacts an agent may make(random) per cycle.
      #   (contacts*(rand+rand)).to_i.times do ...
      # Definitely a prescription parameter.
      @contacts = contacts
    end

    def to_s
      sprintf <<-BEHAVIOR, @travel, @contacts
# Behavior
    Travel:   %d
    Contacts: %.1f
      BEHAVIOR
    end
  end
end
