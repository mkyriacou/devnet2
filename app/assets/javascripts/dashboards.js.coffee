# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  #first set two global vars until I find a better way to do this
  currentProjectId = null
  currentPollId = null

  mkStdDelay = 10000

  # set up functionalized tempates ... eventually should be the same template
  projTemplate = _.template('<hr><tr><button class="btn btn-primary" id="<%= thisProject.id %>"><%= thisProject.title %></button></tr>')

  publicProjTemplate = _.template('<hr><tr><button class="btn btn-success" id="<%= thisProject.id %>"><%= thisProject.title %></button></tr>')

  # just deleted the div at the end of the proj template
  pollTemplate = _.template('<hr><tr><button class="btn btn-primary" id="<%= thisPoll.id %>"><%= thisPoll.title %></button></tr>')

  publicPollTemplate = _.template('<hr><tr><button class="btn btn-success" id="<%= thisPoll.id %>"><%= thisPoll.title %></button></tr>')


  # Naviage a user back to home state
  $("#home-nav").click ->
    $("#main-title").html("Welome to your Silicon Rally Projects Page")
    $("#project-listing-div").removeClass('hidden', mkStdDelay)
    $('#new-project').removeClass('hidden', mkStdDelay)
    $('#show-me-projects').removeClass('hidden', mkStdDelay)
    $('#community-btn').removeClass('hidden', mkStdDelay)

    $('#all-polls').addClass('hidden', mkStdDelay)
    $("#selected-project").addClass('hidden', mkStdDelay)
    $("#all-project-polls").addClass('hidden', mkStdDelay)
    $("#selected-poll").addClass('hidden', mkStdDelay)
    $("#new-project-form").addClass('hidden', mkStdDelay)
    $("#new-poll-form").addClass('hidden', mkStdDelay)
    $('#all-poll-questions').addClass('hidden', mkStdDelay)

    $('#all-users').addClass('hidden', mkStdDelay)
    $('#all-projects').addClass('hidden', mkStdDelay)
    $('#all-polls').addClass('hidden', mkStdDelay)


  $('#community-btn').click ->
    $("#main-title").html("Explore creative works by the community...")
    $('#all-users').removeClass('hidden', mkStdDelay)
    $('#all-projects').removeClass('hidden', mkStdDelay)
    $('#all-polls').removeClass('hidden', mkStdDelay)

    $("#selected-project").addClass('hidden', mkStdDelay)
    $("#project-listing-div").addClass('hidden', mkStdDelay)
    $('#show-me-projects').addClass('hidden', mkStdDelay)
    $('#community-btn').addClass('hidden', mkStdDelay)
    $('#new-project').addClass('hidden', mkStdDelay)
    $('#show-me-projects').addClass('hidden', mkStdDelay)


  # =====================================================
  # =====================================================
  # =====================================================

  # KEY USE CASE:  Show all PUBLIC Projects
  # ================================================

  $('#all-projects').click ->
    # Similar to populate project list but needs to feel different
    $('#community-container').empty()
    $('#community-container').removeClass('hidden')
    $.get '/projects/publicproj', (successData) ->
      for thisProject in successData
        $('#community-container').append(publicProjTemplate({thisProject: thisProject}))


  # KEY USE CASE:  Show all PUBLIC Polls
  # ================================================

  $('#all-polls').click ->
    $('#community-container').empty()
    $('#community-container').removeClass('hidden')
    $.get '/polls/publicpolls', (successData) ->
      alert "check console"
      console.log "the whole return "+successData
      for thisPoll in successData
        $('#community-container').append(publicPollTemplate({thisPoll: thisPoll}))


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
    $('#all-poll-questions').addClass('hidden', mkStdDelay)

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
    $('#all-poll-questions').addClass('hidden', mkStdDelay)

  # CANCEL New Project Form
  $('#cancel-new-project').click ->
    $('#new-proj-title').val("")
    $('#new-proj-description').val("")
    $('#new-project-form').addClass('hidden', mkStdDelay)

  # SAVE New Project Form
  $('#save-new-project-details').click ->
    $title = $('#new-proj-title').val()
    $description = $('#new-proj-description').val()

  # $( "input[name=public_proj]" ).click ->
    if $( "input:checked" ).val() == "public"
      $public_proj = true
      alert "its public"
    else
      $public_proj = false
      alert "its private"


    $userId = $("#owner").val()
    projDetails = {details: {title: $title, description: $description, public_proj: $public_proj, user_id: $userId}}
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
    # alert "working with this as project id: "
    # get show - to grab all details and populate selected project div
    $.get '/projects/'+currentProjectId, (thisProject) ->
      $('#new-poll-form').addClass('hidden', mkStdDelay)
      $("#all-project-polls").addClass('hidden', mkStdDelay)
      $("#selected-poll").addClass('hidden', mkStdDelay)
      $("#new-project-form").addClass('hidden', mkStdDelay)
      $("#project-listing-div").addClass('hidden', mkStdDelay)
      $('#all-poll-questions').addClass('hidden', mkStdDelay)

      $('#selected-project h3').empty()
      $('#selected-project h4').empty()
      $('#selected-project').removeClass('hidden', mkStdDelay)
      # unacceptable - put this into a template or JST!!
      $('#selected-project h3').append("PROJECT: "+thisProject[0].title)
      $('#selected-project h4').append(thisProject[0].description)

      # now get the poll list for that project, as clickable buttons...
      $.get '/projects/'+currentProjectId+'/polls', (pollsForThisProject) ->

        $("#all-project-polls").empty().removeClass('hidden', mkStdDelay)
        if pollsForThisProject == []
          alert "empty state triggered"
          $('#selected-project').append("<p>ooops!  you don't have any polls yet - click add to create new poll</p>")
        else
          $('#all-project-polls table').empty()
          for thisPoll in pollsForThisProject
            $('#all-project-polls').append(pollTemplate(thisPoll: thisPoll))


  $('#view-all-polls').click ->
    if currentProjectId != null
      populateProjectSelected(currentProjectId)


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

    $('#all-poll-questions').addClass('hidden', mkStdDelay)
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


  populatePollSelected = (pollId) ->
    currentPollId = pollId
    $("#selected-project").removeClass('hidden', mkStdDelay)
    $("#selected-poll").removeClass('hidden', mkStdDelay)
    $('#all-poll-questions').removeClass('hidden', mkStdDelay)
    $('#poll-builder-buttons').removeClass('hidden', mkStdDelay)

    $("#all-project-polls").addClass('hidden', mkStdDelay)
    $("#project-listing-div").addClass('hidden', mkStdDelay)

    # Get poll details
    $.get '/projects/'+currentProjectId+'/polls/'+currentPollId, (thisPoll) ->
      $('#selected-poll h4').empty()
      $('#selected-poll h5').empty()

      $('#selected-poll h4').append('<hr>SURVEY:  '+thisPoll.title)
      $('#selected-poll h5').append(thisPoll.description+'<hr>')

    # Get questions so far
    $.get '/projects/'+currentProjectId+'/polls/'+currentPollId+'/text_questions', (successData) ->
      console.log successData
      $('#all-poll-questions table').empty()
      $('#all-poll-questions').removeClass('hidden', mkStdDelay)
      $('#all-poll-questions table').append('<hr>')
      qNum = 1
      for thisQuestion in successData
        # IMPORTANT!  CONVERT TO JST !!
        $('#all-poll-questions table').append("<tr><td>"+qNum+".  "+thisQuestion.question_text+"<hr></td></tr>")
        qNum++


    # KEY USE CASE:  ADD QUESTION to a poll
    # =========================================
    $('#add-text-q').click ->
      event.preventDefault()
      $('#new-text-q-form').removeClass('hidden', mkStdDelay)

      #save q
      $('#save-new-text-q').click ->
        $newTextQ = $('#new-text-q').val()
        $pollId = currentPollId
        newQDetails = {details: {poll_id: $pollId, question_text: $newTextQ}}
        console.log newQDetails
        $.post '/projects/'+currentProjectId+'/polls/'+currentPollId+'/text_questions', (newQDetails), (successData) ->
          alert "Just Saved " + successData.question_text
          console.log successData
          $('#new-text-q').val("")
          $('#new-text-q-form').addClass('hidden', mkStdDelay)
          populatePollSelected(currentPollId)

      #cancel q
      $('#cancel-new-text-q').click ->
        alert "should dissapear"
        $('#new-text-q').val("")

        $('#new-text-q-form').addClass('hidden', mkStdDelay)




  # Key Use Case:  SELECT A POLL and GET QUESTIONS
  # =====================================================
  # # When a poll - to be populated in the future - is clicked get ID and get more details
  $('#all-project-polls').on "click", "button", ->
    currentPollId = $(this).attr('id')
    populatePollSelected(currentPollId)

# ===================================================================================
# NEXT ITEM RIGHT HERE!!!!
# MK next step: don't hve different divs, just switch classes on the same id to reuse
# ===================================================================================


  # =====================================================
  # =====================================================
  # =====================================================







# JST['views/whatever']({id: "4", })


  # =====================================================
  # =====================================================
  # =====================================================


  $('#').click ->

