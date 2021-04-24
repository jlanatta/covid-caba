module ApplicationHelper
  def bootstrap_class_for_flash(flash_type)
    bootstrap_classes = {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info"
    }.stringify_keys

    bootstrap_classes[flash_type] || flash_type.to_s
  end
end
