require_relative 'utils'

Sequel.migration do

  up do
    [:resource].each do |table|
      self[table].update(:system_mtime => Time.now)
    end
  end


  down do
  end

end
