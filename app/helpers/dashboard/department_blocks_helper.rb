module Dashboard::DepartmentBlocksHelper
  def common_params(scope)
    common_params = {}
    common_params.merge!({per_page: scope.per_page}) if scope.per_page.present?
    common_params.merge!({charity: scope.charity}) if scope.charity.present?
    common_params.merge!({role: scope.role}) if scope.role.present?
    common_params.merge!({order_charity: scope.order_charity}) if scope.order_charity.present?
    common_params.merge!({order_role: scope.order_role}) if scope.order_role.present?
    common_params.merge!({order_name: scope.order_name}) if scope.order_name.present?
    common_params.merge!({order_email: scope.order_email}) if scope.order_email.present?
    common_params.merge!({q: scope.q}) if scope.q.present?
    common_params
  end
end