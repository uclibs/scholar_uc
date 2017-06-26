# frozen_string_literal: true
module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def sorted_college_list_for_works(object)
    if object.is_a? Etd
      sorted_college_list_for_etds
    elsif object.is_a? StudentWork
      sorted_college_list_for_student_works
    else
      sorted_college_list_for_other_works
    end
  end

  def sorted_college_list_for_etds
    [''] + sorted_college_list_for_degrees + COLLEGE_AND_DEPARTMENT["legacy_colleges"]
  end

  def sorted_college_list_for_degrees
    COLLEGE_AND_DEPARTMENT["current_colleges_for_degrees"].keys.collect do |k|
      COLLEGE_AND_DEPARTMENT["current_colleges_for_degrees"][k]["label"]
    end.sort << "Other"
  end

  def sorted_college_list_for_student_works
    list = COLLEGE_AND_DEPARTMENT["current_colleges_for_degrees"].merge(COLLEGE_AND_DEPARTMENT["additional_current_colleges"])
    [''] + list.keys.collect do |k|
      list[k]["label"]
    end.sort << "Other"
  end

  def sorted_college_list_for_other_works
    list = COLLEGE_AND_DEPARTMENT["current_colleges_for_degrees"].merge(
      COLLEGE_AND_DEPARTMENT["additional_current_colleges_library"]
    )
    list.keys.collect do |k|
      list[k]["label"]
    end.sort << "Other"
  end

  def user_college(object)
    if (object.is_a? Hyrax::EtdForm) || (object.is_a? Hyrax::StudentWorkForm)
      ''
    else
      current_user.college
    end
  end

  def user_department(object)
    if (object.is_a? Hyrax::EtdForm) || (object.is_a? Hyrax::StudentWorkForm)
      ''
    else
      current_user.department
    end
  end

  def old_or_new_college(object)
    if object.college.empty?
      user_college(object)
    else
      object.college
    end
  end

  def old_or_new_department(object)
    if object.department.empty?
      user_department(object)
    else
      object.department
    end
  end

  def filtered_facet_field_names
    ## only show department if college is set in params
    cache = facet_field_names
    if params["f"].nil?
      cache.delete("department_sim")
      return cache
    end
    if params["f"]["college_sim"].nil?
      cache.delete("department")
      return cache
    end
    cache
  end

  def sorted_genre_list_for_works
    if (curation_concern.is_a? Document) || (params[:payload_concern] == "Document")
      sorted_genre_list_for_documents
    elsif (curation_concern.is_a? StudentWork) || (params[:payload_concern] == "StudentWork")
      sorted_genre_list_for_student_works
    elsif (curation_concern.is_a? Image) || (params[:payload_concern] == "Image")
      sorted_genre_list_for_images
    else
      sorted_genre_list_for_other_works
    end
  end

  def sorted_genre_list_for_documents
    GENRE_TYPES_DOCUMENT["terms"].keys.collect do |k|
      GENRE_TYPES_DOCUMENT["terms"][k]["label"]
    end.sort
  end

  def sorted_genre_list_for_student_works
    GENRE_TYPES_STUDENTWORK["terms"].keys.collect do |k|
      GENRE_TYPES_STUDENTWORK["terms"][k]["label"]
    end.sort
  end

  def sorted_genre_list_for_images
    GENRE_TYPES_IMAGE["terms"].keys.collect do |k|
      GENRE_TYPES_IMAGE["terms"][k]["label"]
    end.sort
  end

  def sorted_genre_list_for_other_works
    GENRE_TYPES_STUDENTWORK["terms"].keys.collect do |k|
      GENRE_TYPES_STUDENTWORK["terms"][k]["label"]
    end.sort
  end
end
