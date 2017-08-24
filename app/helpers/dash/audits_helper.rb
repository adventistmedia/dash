module Dash::AuditsHelper

  def audit_action_icon(action)
    case action
    when 'create'
      'plus'
    when 'destroy'
      'trash'
    else # update
      "pencil"
    end
  end

  def audit_summary(audit)
    case action
    when "create"
      "Created"
    when "destroy"
      "Deleted"
    when "update"
      audit_update_summary(audit.audited_changes)
    end
  end

  def audit_update_summary(changes)

    if achanges.length == 1
      name = changes.keys.first
      name.gsub!(/_id\Z/, '')
      "#{name.titleize} changed"
    else
      "Edited"
    end
  end
end