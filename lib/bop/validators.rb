class LocalSlugUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :taken) if !record.root? && record.siblings.find_by_slug(record.slug)
  end
end

class PresenceUnlessRootValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :taken) if record.slug.blank? && !record.root?
  end
end
