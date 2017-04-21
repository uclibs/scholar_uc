# frozen_string_literal: true
module SufiaHelper
  include ::BlacklightHelper
  include Sufia::BlacklightOverride
  include Sufia::SufiaHelperBehavior

  def sorted_college_list_for_works
    if curation_concern.is_a? Etd
      sorted_college_list_for_etds
    elsif curation_concern.is_a? StudentWork
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

  def user_college
    if (curation_concern.is_a? Etd) || (curation_concern.is_a? StudentWork)
      ''
    else
      current_user.college
    end
  end

  def user_department
    if (curation_concern.is_a? Etd) || (curation_concern.is_a? StudentWork)
      ''
    else
      current_user.department
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
end
