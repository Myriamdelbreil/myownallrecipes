module RecipesHelper
  def render_stars(rating)
    return if rating.blank? || rating.zero?

    rounded_rating = (rating * 2).round / 2.0
    full_stars = rounded_rating.to_i
    half_star = (rounded_rating % 1) != 0
    empty_stars = 5 - full_stars - (half_star ? 1 : 0)

    content_tag(:div, class: "recipe-stars d-inline-flex align-items-center gap-1") do
      full_stars.times { concat content_tag(:i, "", class: "bi bi-star-fill text-secondary") }

      concat content_tag(:i, "", class: "bi bi-star-half text-secondary") if half_star

      empty_stars.times { concat content_tag(:i, "", class: "bi bi-star text-muted") }

      concat content_tag(:span, "(#{rating.round(1)})", class: "text-muted ms-1 small")
    end
  end

  def recipe_image_for(recipe)
    image_path = recipe.image_url.presence || "generic.jpg"

    image_tag image_path,
              class: "card-img-top",
              alt: recipe.title,
              loading: "lazy",
              onerror: "this.error=null;this.src='#{asset_path('generic.jpg')}';"
  end
end
