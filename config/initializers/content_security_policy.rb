# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |p|
    p.default_src :self, :https
    p.script_src  :self, :https
    p.style_src   :self, :https
    p.img_src     :self, :https, :data
    p.font_src    :self, :https, :data
    p.connect_src :self, :https
    p.object_src  :none
    p.frame_ancestors :none
    p.base_uri :self
  end

  #   # Generate session nonces for permitted importmap, inline scripts, and inline styles.
  #   config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  #   config.content_security_policy_nonce_directives = %w(script-src style-src)
  #
  #   # Report violations without enforcing the policy.
  #   # config.content_security_policy_report_only = true
end
