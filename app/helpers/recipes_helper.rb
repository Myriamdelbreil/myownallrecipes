module RecipesHelper
  def render_stars(rating)
    return if rating.blank? || rating.zero?

    rounded_rating = (rating * 2).round / 2.0
    full_stars = rounded_rating.to_i
    half_star = (rounded_rating % 1) != 0
    empty_stars = 5 - full_stars - (half_star ? 1 : 0)

    content_tag(:div, class: "recipe-stars d-inline-flex align-items-center gap-1") do
      full_stars.times { concat content_tag(:i, "", class: "bi bi-star-fill text-primary") }

      concat content_tag(:i, "", class: "bi bi-star-half text-primary") if half_star

      empty_stars.times { concat content_tag(:i, "", class: "bi bi-star text-muted") }

      concat content_tag(:span, "(#{rating.round(1)})", class: "text-muted ms-1 small")
    end
  end
end
