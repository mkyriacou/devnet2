# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  #first set two global vars until I find a better way to do this
  currentProjectId = null
  currentPollId = null

  mkStdDelay = 10000

  # set up functionalized tempates ... eventually should be the same template
  projTemplate = _.template('<hr><tr><button class="btn btn-primary" id="<%= thisProject.id %>""><%= thisProject.title %></button></tr>')
  # just deleted the div at the end of the proj template
  pollTemplate = _.template('<hr><tr><button class="btn btn-primary" id="<%= thisPoll.id %>""><%= thisPoll.title %></button></tr>')


  # Naviage a user back to home state
  $("#home-nav").click ->
    $("#project-listing-div").removeClass('hidden', mkStdDelay)

    $("#selected-project").addClass('hidden', mkStdDelay)
    $("#all-project-polls").addClass('hidden', mkStdDelay)
    $("#selected-poll").addClass('hidden', mkStdDelay)
    $("#new-project-form").addClass('hidden', mkStdDelay)
    $("#new-poll-form").addClass('hidden', mkStdDelay)


  # =====================================================
  # =====================================================
  # =====================================================

  # KEY USE CASE:  Show all Projects for a User!
  # ================================================
  populateProjectList = () ->
    $("#project-listing-div").removeClass('hidden', mkStdDelay)

    $("#selected-project").addClass('hidden', mkStdDelay)
    $("#all-project-polls").addClass('hidden', mkStdDelay)
    $("#selected-poll").addClass('hidden', mkStdDelay)

    $.get '/projects', (allProjs) ->
      $('#project-listing').empty()
      for thisProject in allProjs
        $('#project-listing').append(projTemplate({thisProject: thisProject}))

  $('#show-me-projects').click ->
    populateProjectList()


  # KEY USE CASE:  Create a new project
  # ===================================
  # Make New Project Form visible
  $('#new-project').click ->
    $('#new-project-form').removeClass('hidden', mkStdDelay)
    $("#project-listing-div").removeClass('hidden', mkStdDelay)

    $("#selected-project").addClass('hidden', mkStdDelay)
    $("#all-project-polls").addClass('hidden', mkStdDelay)
    $("#selected-poll").addClass('hidden', mkStdDelay)

  # CANCEL New Project Form
  $('#cancel-new-project').click ->
    $('#new-proj-title').val("")
    $('#new-proj-description').val("")
    $('#new-project-form').addClass('hidden', mkStdDelay)

  # SAVE New Project Form
  $('#save-new-project-details').click ->
    $title = $('#new-proj-title').val()
    $description = $('#new-proj-description').val()
    $userId = $("#owner").val()
    projDetails = {details: {title: $title, description: $description, user_id: $userId}}
    console.log projDetails
    $('#new-proj-title').val("")
    $('#new-proj-description').val("")
    $('#new-project-form').addClass('hidden', mkStdDelay)

    $.post '/projects',
      projDetails,
      (responseData) ->
        currentProjectId = responseData.id
        populateProjectSelected(currentProjectId)

  # FIRST thing:  Populate the user page with their projects.  Even if it's invisible for now.
  populateProjectList()


  # KEY USE CASE:  Select A Project To CRUD Details
  # ===========================================================================


  populateProjectSelected = (projectId) ->
    # currentProjectId = projectId
    alert "working with this as project id: "
    # get show - to grab all details and populate selected project div
    $.get '/projects/'+currentProjectId, (thisProject) ->
      $('#new-poll-form').addClass('hidden', mkStdDelay)
      $("#all-project-polls").addClass('hidden', mkStdDelay)
      $("#selected-poll").addClass('hidden', mkStdDelay)
      $("#new-project-form").addClass('hidden', mkStdDelay)
      $("#project-listing-div").addClass('hidden', mkStdDelay)

      $('#selected-project h3').empty()
      $('#selected-project h4').empty()
      $('#selected-project').removeClass('hidden', mkStdDelay)
      # unacceptable - put this into a template or JST!!
      $('#selected-project h3').append("PROJECT: "+thisProject[0].title)
      $('#selected-project h4').append(thisProject[0].description)

      # now get the poll list for that project, as clickable buttons...
      $.get '/projects/'+currentProjectId+'/polls', (pollsForThisProject) ->

        $("#all-project-polls").removeClass('hidden', mkStdDelay)
        if pollsForThisProject == []
          alert "empty state triggered"
          $('#selected-project').append("<p>ooops!  you don't have any polls yet - click add to create new poll</p>")
        else
          $('#all-project-polls table').empty()
          for thisPoll in pollsForThisProject
            $('#all-project-polls table').append(pollTemplate(thisPoll: thisPoll))


  #Event trigger  - when a project's button is pressed
  $('table#project-listing').on "click", "button", ->
    # get corresponding project id
    currentProjectId = $(this).attr('id')
    populateProjectSelected(currentProjectId)


  # =====================================================
  # =====================================================
  # =====================================================




  # KEY USE CASE: Create New Poll for a SELECTED PROJECT
  # ======================================================================

  # Event trigger which starts use case and reveals previously hidden form
  $("#start-new-poll").click ->
    $('#new-poll-form').removeClass('hidden', mkStdDelay)
    $("#selected-project").removeClass('hidden', mkStdDelay)

    $("#all-project-polls").addClass('hidden', mkStdDelay)
    $("#selected-poll").addClass('hidden', mkStdDelay)
    $("#new-project-form").addClass('hidden', mkStdDelay)
    $("#project-listing-div").addClass('hidden', mkStdDelay)

    # SAVE button
    $('#save-new-poll-details').click ->
      $title = $('#new-poll-title').val()
      $description = $('#new-poll-description').val()
      $project_id = currentProjectId
      newPollDetails = {details: {title: $title, description: $description, project_id: currentProjectId}}
      # alert "soon we will be posting a save of the following new poll: " + $title + " - " + $description
      $.post '/projects/'+currentProjectId+'/polls', (newPollDetails), (successData) ->
        alert "got back " + successData.title
        alert "current project id is " +currentProjectId

    # CANCEL button
    $('#cancel-new-poll').click ->
      $('#new-poll-title').val("")
      $('#new-poll-description').val("")
      $('#new-poll-form').addClass('hidden', mkStdDelay)

    # ADD TEXT QUESTION button
    $('#add-text-q').click ->
      event.preventDefault()
      $('#new-text-q-form').removeClass('hidden', mkStdDelay)

      #save q
      $('#save-new-text-q').click ->
        $newTextQ = $('#new-text-q').val()
        $pollId = currentPollId
        newQDetails = {details: {poll_id: $pollId, question_text: $newTextQ}}
        alert "will save soon!"
        $.post '/projects/'+currentProjectId+'/polls/'+currentPollId+'/text_question', (newQDetails), (successData) ->
          alert "check console now!"
          console.log successData

      #cancel q
      $('#cancel-new-text-q').click ->
        $('#new-text-q').val("")
        $('#new-text-q-form').addClass('hidden', mkStdDelay)

  populatePollSelected = (pollId) ->
    currentPollId = pollId
    $("#selected-project").removeClass('hidden', mkStdDelay)
    $("#selected-poll").removeClass('hidden', mkStdDelay)

    $("#all-project-polls").addClass('hidden', mkStdDelay)
    $("#project-listing-div").addClass('hidden', mkStdDelay)

    $.get '/projects/'+currentProjectId+'/polls/'+currentPollId, (thisPoll) ->
      $('#selected-poll span').empty()
      $('#selected-poll span').append('<hr>'+thisPoll.title+' - '+thisPoll.description+'<hr>')


  # Key Use Case:  SELECT A POLL and GET QUESTIONS
  # =====================================================
  # # When a poll - to be populated in the future - is clicked get ID and get more details
  $('#all-project-polls table').on "click", "button", ->
    currentPollId = $(this).attr('id')
    event.preventDefault()

    populatePollSelected(currentPollId)


  # =====================================================
  # =====================================================
  # =====================================================


    # now get ALL the questions ascociated with this poll.
    #
    #
    #
    #
    alert "about to get all questions"
    $.get '/projects/'+currentProjectId+'/polls/'+currentPollId+'/text_question', (successData) ->
      console.log successData
      for thisQuestion in successData
        alert "just retreived from db " + thisQuestion.question_text
        console.log thisQuestion





# JST['views/whatever']({id: "4", })


  # =====================================================
  # =====================================================
  # =====================================================


  $('#').click ->

