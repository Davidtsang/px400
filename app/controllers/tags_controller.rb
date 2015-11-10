class TagsController < ApplicationController


  #create Lable
  def create_label
    tag = where_or_create_tag(Label, tags_params[:name])

    WorksTag.create(work_id: params[:work_id] , tag_id: tag.id )

    @tags = WorksTag.where(work_id: params[:work_id])
    respond_to do |format|
      format.js
    end
  end

  #create Skill
  def create

    tag = where_or_create_tag(Skill, tags_params[:name])

    current_user.users_tags.create(tag_id: tag.id )

    respond_to do |format|
      format.js
    end

  end

  #AJAX REMOVE WORK TAG
  def remove_work_tag
    tag = WorksTag.find (params[:id])
    @tags = WorksTag.where(tag.work_id)
    tag.destroy


    respond_to do |format|
      format.js

    end

  end

  #AJAX REMOVE SKILL TAG
  def remove_skill_tag
    user_tag = UsersTag.find (params[:id])
    user_tag.destroy

    respond_to do |format|
      format.js

    end

  end

  def suggest

    #query puts params
    qstring = params[:query]
    if params[:type] == "Label"
      @tags = Label.search(qstring)
    else
      @tags = Tag.search(qstring)
    end

    result ={}
    result["query"] = qstring
    result["suggestions"] = []

    @tags.each do |t|
      result["suggestions"].append({value: t.name, data: t.name})
    end
    respond_to do |format|
      format.json { render json: result }
    end

  end

  private
  def where_or_create_tag(obj, name)
    tag = obj.where(name: name)

    if tag.any?
      tag = tag.first
    else
      tag = obj.create(name: name, status: 1)
    end

    tag
  end


  def tags_params
    params.require(:tag).permit([:name, :type])
  end
end
