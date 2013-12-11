# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  #first set a global var until I find a better way to do this
  currentProjectId = null

  # projTemplate (projDataSet) = _.template('<li><button class="btn btn-primary">this_project.title</button></li>')
  projTemplate = _.template('<hr><tr><button class="btn btn-primary" id="<%= thisProject.id %>""><%= thisProject.title %></button></tr><div id="div-<%= thisProject.id %>"></div>')

  $("#start-new-poll").click ->
    $('#new-poll-form').removeClass('hidden')

  $('#save-new-poll-details').click ->
    $title = $('#new-poll-title').val()
    $description = $('#new-poll-description').val()
    $project_id = currentProjectId
    newPollDetails = {details: {title: $title, description: $description, project_id: currentProjectId}}
    alert "soon we will be posting a save of the following new poll: " + $title + " - " + $description
    $.post '/projects/'+currentProjectId+'/polls', (newPollDetails), (successData) ->
      alert "got back " + successData.title
      alert "current project id is " +currentProjectId

  $('#cancel-new-poll').click ->
    $('#new-poll-title').val("")
    $('#new-poll-description').val("")
    $('#new-poll-form').addClass('hidden')


  $('table').on "click", "button", ->
    currentProjectId = $(this).attr('id')
    alert "selectd proj is " + currentProjectId
    $.get '/projects/'+currentProjectId, (thisProject) ->
      idCode = "#div-"+thisProject[0].id
      alert "watch the console for readouts"
      console.log "idcode=" +idCode
      console.log "thisProject[0].id=" + thisProject[0].id
      console.log "thisProject[0].title=" + thisProject[0].title
      console.log "thisProject[0].description=" + thisProject[0].description

      $(idCode).append("<hr><li>"+thisProject[0].title + " - " + thisProject[0].description+"</li>")
      $.get 'projects/'+currentProjectId+'/polls', (pollsForThisProject) ->
        console.log "response from poll get is " + pollsForThisProject
        if pollsForThisProject.empty?
          $(idCode).append("ooops!  you don't have any polls yet - click add to create new poll")
        else
          for thisPoll in pollsForThisProject
            console.log thisPoll.title
          $(idCode).append(thisPoll.title) #these must be delegates soon!
        newPollDivId = "newPoll-"+idCode
        # $(idCode).append('<button id="newPoll" class="btn btn-primary">Create New Poll!</button><div id="<%= newPollDivId %>" ><new-poll><input id="pollTitle" placeholder="poll title"></new-poll><br><button id="saveNewPoll">Save New Poll!</button></div>')

        # $('#newPoll').click ->
        #   $(newPollDivId).removeClass('hidden')
        #   $('#saveNewPoll').click ->
        #     $pollTitle = $('#pollTitle').val()
        #     console.log "Just grabbed " + $pollTitle




  populateProjectList = () ->
    $.get '/projects', (allProjs) ->
      $('#project-listing').empty()
      for thisProject in allProjs
        $('#project-listing').append(projTemplate({thisProject: thisProject}))

  $('#show-me-projects').click ->
    populateProjectList()



  $('#new-project').click ->
    $('#new-project-form').removeClass('hidden')

  $('#cancel-new-project').click ->
    $('#new-proj-title').val("")
    $('#new-proj-description').val("")
    $('#new-project-form').addClass('hidden')

  $('#save-new-project-details').click ->
    $title = $('#new-proj-title').val()
    $description = $('#new-proj-description').val()
    $userId = $("#owner").val()
    projDetails = {details: {title: $title, description: $description, user_id: $userId}}
    console.log projDetails
    $('#new-proj-title').val("")
    $('#new-proj-description').val("")
    $('#new-project-form').addClass('hidden')

    $.post '/projects',
      projDetails,
      (responseData) ->
        console.log responseData.title
        alert "Saved " + responseData.title + "!!"
        populateProjectList