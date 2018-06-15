# frozen_string_literal: true

ActiveAdmin.register College do
  permit_params  :name, :naac, :address , :website, :description, :image_url
end
  