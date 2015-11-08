class TagsController < ApplicationController


  def create

    #create user skill tag
    if tags_params[:type] == "Skill"
      #serch tag exist?
     tag = Skill.search( tags_params[:name])

     if tag.any?
       tag = tag.first
     else
       tag = Skill.create(name: tags_params[:name], status: 1)
     end
     #status 1 user_submited

     UsersTag.create(tag_id: tag.id , user_id: current_user.id )

    end

    respond_to do  |format|
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
    @tags = Tag.search(qstring)
    result ={}
    result["query"] = qstring

    result[ "suggestions"] = []


    @tags.each do |t|
      result[ "suggestions"].append({ value: t.name, data: t.name })
    end
    respond_to do |format|
      format.json { render json: result }
    end


  end

  def tags_params

    params.require(:tag).permit([:name, :type])
  end
end
