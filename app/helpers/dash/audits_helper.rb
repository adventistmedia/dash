module Dash::AuditsHelper

  def audit_action_icon(action)
    case action
    when "create"
      "plus"
    when "destroy"
      "trash"
    else # update
      "pencil"
    end
  end

  def audit_summary(audit)
    case audit.action
    when "create"
      t("dash.audits.audit_action.create")
    when "destroy"
      t("dash.audits.audit_action.destroy")
    when "update"
      audit_update_summary(audit.audited_changes)
    end
  end

  def audit_update_summary(changes)

    if changes.length == 1
      name = changes.keys.first.gsub(/_id\Z/, "")
      t("dash.audits.audit_action.update_summary", field_name: name.titleize)
    else
      t("dash.audits.audit_action.update")
    end
  end
end