class Extent < Sequel::Model(:extent)
  include ASModel
  include TouchRecords
  corresponds_to JSONModel(:extent)

  set_model_scope :global

  def self.touch_records(obj)
    [
      { type: Accession, ids: [obj.accession_id] },
      { type: ArchivalObject, ids: [obj.archival_object_id] },
      { type: Deaccession, ids: [obj.deaccession_id] },
      { type: DigitalObject, ids: [obj.digital_object_id] },
      { type: DigitalObjectComponent, ids: [obj.digital_object_component_id] },
      { type: Resource, ids: [obj.resource_id] },
    ]
  end
end
