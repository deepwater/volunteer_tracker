class Subdomain
  IGNORE_SUBDOMAINS = %w(www api)

  def self.matches?(request)
    request.subdomain.present? && !IGNORE_SUBDOMAINS.include?(request.subdomain)
  end
end