# :stopdoc:
module Api
  module People
    include Api::Base
    
    private
    
    def people_as_xml
      people.to_xml :only => person_fields, :include => person_includes
    end
    
    def people_as_json
      people.to_json :only => person_fields, :include => person_includes
    end

    def person_as_xml
      person.to_xml :only => person_fields, :include => person_includes
    end

    def person_as_json
      person.to_json :only => person_fields, :include => person_includes
    end

    # Queries a collection of Person records from the database.
    # 
    # == Params
    # * page
    # * name
    # * license
    # 
    # == Returns
    # An array of 0 or more Person records, 10 per page, with the necessary
    # joins for rendering a JSON or XML service response.
    # 
    # If no filtering parameter (i.e. name or license) is provided this
    # function will return an empty array.
    def people
      sql = []
      conditions = [""]

      # name
      # jQuery autocomplete uses :term
      name_param = params[:name] || params[:term]
      if name_param.present?
        name = "%#{name_param.strip}%"
        sql << "(CONCAT_WS(' ', first_name, last_name) LIKE ? OR aliases.name LIKE ?)"
        conditions << name << name
      end

      # license
      if params[:license].present?
        sql << "(license = ?)"
        conditions << params[:license]
      end

      if sql
        conditions[0] = sql.join(" AND ")
        Person.paginate(
          :page       => params[:page],
          :per_page   => 10,
          :conditions => conditions,
          :order      => "last_name, first_name",
          :include    => [ :aliases, :team, { :race_numbers =>  :discipline } ]
        )
      else
        []
      end
    end  

    # Retrieves a single Person record from the database with the necessary
    # joins for rendering a JSON or XML service response.
    # 
    # == Params
    # * id
    # 
    # == Returns
    # A Person record, if one is found.
    def person
      Person.find(params[:id], :include => {
        :aliases      => [],
        :team         => [],
        :race_numbers => [:discipline]
      })
    end
  end
end