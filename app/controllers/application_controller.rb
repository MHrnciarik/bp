class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?, :current_company, :missions_ready_to_claim?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def current_company
    return unless logged_in?

    @current_company ||= begin
      selected_company = current_user.companies.find_by(id: session[:current_company_id])
      selected_company ||= current_user.companies.order(:created_at, :id).first

      session[:current_company_id] = selected_company.id if selected_company.present?
      selected_company
    end
  end

  def missions_ready_to_claim?
    return false unless logged_in?

    @missions_ready_to_claim ||= %w[daily weekly].any? do |period|
      ::MissionTracker.progress_for(current_user, period).any?(&:claimable?)
    end
  end

  def require_login
    return if logged_in?

    redirect_to login_path, alert: "Najprv sa prihlás."
  end

  def require_current_company
    return if current_company.present?

    redirect_to profiles_path, alert: "Najprv pridaj alebo vyber firmu."
  end

  def flash_achievements(achievements)
    return if achievements.blank?

    flash[:achievements] = achievements.map { |achievement| achievement.slice(:title, :target) }
  end
end
