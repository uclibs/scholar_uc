CAPTCHA_SERVER = YAML.load_file(Rails.root.join('config', 'recaptcha.yml'))[Rails.env]

