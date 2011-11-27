module Names
  # See Name
  module Nameable
    def self.included(base)
      base.before_save :add_name
      base.has_many :names, :order => "year", :as => :nameable
    end
  
    def name(date_or_year = nil)
      name_record_for_year(parse_year(date_or_year)).try(:name) || read_attribute(:name)
    end
    
    # Returns Name record, not String
    def name_record_for_year(year)
      return nil if year.blank? || year >= Date.today.year || names.none?
      
      # Assume names always sorted
      if year <= names.first.year
        return names.first
      elsif year >= names.last.year
        return names.last
      end
          
      names.detect { |n| n.year == year }
    end

    # Remember names from previous years. Keeps the correct name on old results without creating additional teams.
    # This is a bit naive
    def add_name
      last_year = Time.zone.now.year - 1
      if name_was.present? && results_before_this_year? && self.names.none? { |name| name.year == last_year }
        name = names.build(:name => name_was, :year => last_year)
        if self.respond_to?(:first_name)
          name.first_name = first_name_was
        end
        if self.respond_to?(:last_name)
          name.last_name = last_name_was
        end
        name.save!
      end
    end
  
    def results_before_this_year?
      Result.
        where("#{self.class.name.singularize.foreign_key}" => id).
        where("date < ?", Date.today.beginning_of_year).
        exists?
    end
    
    private
    
    def parse_year(date_or_year)
      case date_or_year
      when NilClass
        nil
      when Integer
        date_or_year
      when String
        date_or_year.to_i
      else
        date_or_year.year
      end
    end
  end
end
