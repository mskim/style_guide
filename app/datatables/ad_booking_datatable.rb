class AdBookingDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "AdBooking.id", cond: :eq },
      date: { source: "AdBooking.date", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        id: record.id,
        date: record.name
      }
    end
  end

  def get_raw_records
    # insert query here
    AdBooking.all
  end

end
