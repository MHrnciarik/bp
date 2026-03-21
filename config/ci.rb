# Run using bin/ci

CI.run do
  step "Setup", "bin/setup --skip-server"

  step "Style: Ruby", "bin/rubocop"

  step "Security: Gem audit", "bin/bundler-audit"
  step "Security: Importmap vulnerability audit", "bin/importmap audit"
  step "Security: Brakeman code analysis", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"
  step "Tests: Rails", "bin/rails test"
  step "Tests: Seeds", "env RAILS_ENV=test bin/rails db:seed:replant"

  # Optional: Run system tests
  # step "Tests: System", "bin/rails test:system"

  # Optional: set a green GitHub commit status to unblock PR merge.
  # Requires the `gh` CLI and `gh extension install basecamp/gh-signoff`.
  # if success?
  #   step "Signoff: All systems go. Ready for merge and deploy.", "gh signoff"
  # else
  #   failure "Signoff: CI failed. Do not merge or deploy.", "Fix the issues and try again."
  # end
  #
  # #CI.run do
  # step "Security: Brakeman", "bin/brakeman --no-pager"
  # step "Security: Bundler Audit", "bin/bundler-audit"
  # step "Security: Importmap Audit", "bin/importmap audit"
  # step "Style: RuboCop", "bin/rubocop"
  # step "Tests", "env RAILS_ENV=test DATABASE_URL=postgres://postgres:postgres@localhost:5432/bp_test bin/rails db:test:prepare test"
end
