# frozen_string_literal: true

# Define an application-wide content security policy.
#
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy.
Rails.application.config.content_security_policy do |policy|
  policy.default_src(:none)
  policy.connect_src(:self, :https)
  policy.script_src(:self, :https)
  policy.style_src(:self, Rails.env.development? ? :unsafe_inline : :https)
  policy.form_action(:self, :https)
end

# If you are using UJS then enable automatic nonce generation
Rails.application.config.content_security_policy_nonce_generator = proc do
  SecureRandom.base64(16)
end
