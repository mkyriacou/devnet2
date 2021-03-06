# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  #first set some ugly global vars until I use Angular to optimize
  currentProjectId = null
  currentProjectOwnerId = null

  currentPollId = null
  currentPollOwnerId = null


  currentUserId = $('#user-data userid').text()
  currentUserName = $('#user-data username').text()

  mkStdDelay = 100
  textAreaRows = 3
  textAreaWidth = 80

  $.fn.serializeObject = ->
    o = {}
    a = @serializeArray()
    $.each a, ->
      if o[@name] isnt `undefined`
        o[@name] = [o[@name]]  unless o[@name].push
        o[@name].push @value or ""
      else
        o[@name] = @value or ""
    o

  # set up functionalized tempates ... eventually should be the same template
  # projTemplate = _.template('<hr><tr><button class="btn btn-primary" id="<%= thisProject.id %>"><%= thisProject.title %></button></tr>')
  # pollTemplate = _.template('<hr><tr><button class="btn btn-primary" id="<%= thisPoll.id %>"><%= thisPoll.title %></button></tr>')


  # Define new primitive based on custom routes
  getModelData = (thisController, thisId) ->
    # assumes you have the correct controller name and id, otherwise all bets are off!
    successData = null
    alert 'trying this: /'+thisController+'/'+thisId
    $.get '/'+thisController+'/'+thisId, (successData) ->
      return successData

  getProjFromPollId = (pollId) ->
    # PRE:  poll_id
    # POST: corresponding project instance
    projId = getModelData(polls, pollId).project_id
    getModelData(projects, projId)


  getOwnerFromPollId = (pollId) ->
    # PRE:  poll_id
    # POST: corresponding user instance
    getProjFromPollId(pollId).user_id

  homeState = () ->
    # Switch Div modes
    $("#project-listing-div").removeClass('community').addClass('own')
    $("#selected-project").removeClass('community').addClass('own')
    $("#all-project-polls").removeClass('community').addClass('own')
    $("#selected-poll").removeClass('community').addClass('own')

    # Make desired divs appear
    $("#main-title").html(currentUserName+"'s own Apps")
    $("#project-listing-div").removeClass('hidden', mkStdDelay)
    $('#new-project').removeClass('hidden', mkStdDelay)
    $('#show-me-projects').removeClass('hidden', mkStdDelay)
    $('#community-btn').removeClass('hidden', mkStdDelay)

    # Hide irrelevant divs
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

  # Naviage a user back to home state
  $("#home-nav").click ->
    homeState()

  communityState = () ->
    # Switch Div modes
    $("#project-listing-div").removeClass('own').addClass('community')
    $("#selected-project").removeClass('own').addClass('community')
    $("#all-project-polls").removeClass('own').addClass('community')
    $("#selected-poll").removeClass('own').addClass('community')
    $('#all-poll-questions').addClass('community')

    # Make desired divs appear
    $("#main-title").html("Apps by fellow creators...")
    $('#all-users').removeClass('hidden', mkStdDelay)
    $('#all-projects').removeClass('hidden', mkStdDelay)
    $('#all-polls').removeClass('hidden', mkStdDelay)

    $('#all-poll-questions').addClass('hidden', mkStdDelay)
    $("#selected-project").addClass('hidden', mkStdDelay)
    $("#project-listing-div").addClass('hidden', mkStdDelay)
    $('#show-me-projects').addClass('hidden', mkStdDelay)
    $('#community-btn').addClass('hidden', mkStdDelay)
    $('#new-project').addClass('hidden', mkStdDelay)
    $('#show-me-projects').addClass('hidden', mkStdDelay)

  $('#community-btn').click ->
    communityState()


  # =====================================================
  # =====================================================
  # =====================================================

  # KEY USE CASE:  Show all PUBLIC Projects
  # ================================================


  $('#all-projects').click ->
    # $('#project-listing-div').addClass('hidden')
    public_flag = true
    populateProjectList(public_flag)
    $('#project-listing button').removeClass('btn-primary').addClass('btn-success')




  # KEY USE CASE:  Show all PUBLIC Polls
  # ================================================

  $('#all-polls').click ->
    $("#project-listing-div").addClass('hidden')
    $('#all-project-polls table').empty()
    $.get '/publicpolls', (successData) ->
      for thisPoll in successData
        $('#all-project-polls table').append(JST["templates/poll/poll-dir"]({thisPoll: thisPoll}))
      $('#all-project-polls table button').removeClass('btn-primary').addClass('btn-success')
      $('#all-project-polls').removeClass('hidden')

  # =====================================================
  # =====================================================
  # =====================================================

  # KEY USE CASE:  Show all Projects for a User!
  # ================================================
  populateProjectList = (public_flag) ->
    # PRE:  We use a boolean switch:  public_flag.  We make a different ajax call based on
    #       where we need to take the input from

    $("#project-listing-div").removeClass('hidden', mkStdDelay)

    $("#selected-project").addClass('hidden', mkStdDelay)
    $("#all-project-polls").addClass('hidden', mkStdDelay)
    $("#selected-poll").addClass('hidden', mkStdDelay)
    $('#all-poll-questions').addClass('hidden', mkStdDelay)


    if public_flag == true
      route_string = '/projects/publicproj'
    else
      route_string = '/projects'

    $.get route_string, (allProjs) ->
      $('#project-listing').empty()
      for thisProject in allProjs

        $('#project-listing').append JST['templates/project/proj-dir']({thisProject: thisProject})

        # $('#project-listing').append(projTemplate({thisProject: thisProject}))



  # FIRST thing after page load:  Populate the user page with their projects.  Even if it's invisible for now.
  homeState()






  $('#show-me-projects').click ->
    public_flag = false
    populateProjectList(public_flag)


  # KEY USE CASE:  Create a new project
  # ===================================
  $('#new-project').click ->
    # Make New Project Form visible
    $('#new-project-form').removeClass('hidden', mkStdDelay)

    $('#new-project').addClass('hidden', mkStdDelay)
    $("#project-listing-div").addClass('hidden', mkStdDelay)
    $("#selected-project").addClass('hidden', mkStdDelay)
    $("#all-project-polls").addClass('hidden', mkStdDelay)
    $("#selected-poll").addClass('hidden', mkStdDelay)
    $('#all-poll-questions').addClass('hidden', mkStdDelay)

    # CANCEL New Project Form
    $('#cancel-new-project').click ->
      $('#new-project').removeClass('hidden', mkStdDelay)
      $("#project-listing-div").removeClass('hidden', mkStdDelay)
      $('#new-proj-title').val("")
      $('#new-proj-description').val("")
      $('#new-project-form').addClass('hidden', mkStdDelay)

    # SAVE New Project Form
    $('#save-new-project-details').click ->
      $("#project-listing-div").removeClass('hidden', mkStdDelay)
      $('#new-project').removeClass('hidden', mkStdDelay)

      $title = $('#new-proj-title').val()
      $description = $('#new-proj-description').val()

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



  # KEY USE CASE:  Select A Project To CRUD Details
  # ===========================================================================



  populateProjectSelected = (projectId) ->
    # set selected project as the current projectID
    currentProjectId = projectId

    # get show - to grab all details and populate selected project div
    $.get '/projects/'+currentProjectId, (thisProject) ->
      $('#new-poll-form').addClass('hidden', mkStdDelay)
      $("#selected-poll").addClass('hidden', mkStdDelay)
      $("#new-project-form").addClass('hidden', mkStdDelay)
      $("#project-listing-div").addClass('hidden', mkStdDelay)

      $('#all-poll-questions').addClass('hidden', mkStdDelay)

      $('#selected-project h3').empty()
      $('#selected-project h4').empty()
      $('#selected-project').removeClass('hidden', mkStdDelay)
      $("#all-project-polls").removeClass('hidden', mkStdDelay)

      # unacceptable - put this into a template or JST!!
      # Poll heading
      $('#selected-project h3').append("PROJECT: "+thisProject[0].title)
      $('#selected-project h4').append(thisProject[0].description)

      # now get the poll list for that project, as clickable buttons...
      $.get '/projects/'+currentProjectId+'/polls', (pollsForThisProject) ->

        $("#all-project-polls table").empty().removeClass('hidden', mkStdDelay)
        if pollsForThisProject == []
          alert "empty state triggered"
          $('#selected-project').append("<p>ooops!  you don't have any polls yet - click add to create new poll</p>")
        else
          $('#all-project-polls table').empty()
          for thisPoll in pollsForThisProject
            # $('#all-project-polls table').append(pollTemplate({thisPoll: thisPoll}))
            $('#all-project-polls table').append(JST["templates/poll/poll-dir"]({thisPoll: thisPoll}))

      # alert +currentUserId+" "+thisProject[0].user_id
      if +currentUserId == +thisProject[0].user_id
        $('#selected-project p').empty().html("Browsing YOUR OWN project...")
        $('#start-new-poll').removeClass('hidden')
        # alert "this is yours"
      else
        ownerName = getModelData('users', thisProject[0].user_id).name
        console.log ownerName
        # alert "check console"
        $('#selected-project p').empty().html("Browsing a project by user "+ownerName)
        $('#start-new-poll').addClass('hidden')
        alert "browsing comunity"
#
#
#
#
#
#
#
#
#



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
        # alert "got back " + successData.title
        # alert "current project id is " +currentProjectId
        $('#new-poll-title').val("")
        $('#new-poll-description').val("")
        $('#new-poll-form').addClass('hidden', mkStdDelay)

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

      $('#selected-poll h4').append('SURVEY:  '+thisPoll.title)
      $('#selected-poll h5').append(thisPoll.description+'<hr>')

    # Get questions so far
    $.get '/projects/'+currentProjectId+'/polls/'+currentPollId+'/text_questions', (successData) ->
      console.log successData
      $('#all-poll-questions table').empty()
      $('#all-poll-questions').removeClass('hidden', mkStdDelay)
      # $('#all-poll-questions table').append('<hr>')
      qNum = 1
      for thisQuestion in successData
        # IMPORTANT!  CONVERT TO JST !!
        $('#all-poll-questions table').append("<tr><center><td>"+qNum+".  "+thisQuestion.question_text+"<br>  <textarea rows='"+textAreaRows+"' cols='"+textAreaWidth+"' placeholder='enter response here' ></textarea></td></center></tr>")
        #extracted part: id='resp'"+thisQuestion.id+"
        qNum++


  # KEY USE CASE:  ADD QUESTION to a poll
  # =========================================
  $('#add-text-q').click ->
    event.preventDefault()
    $('#poll-builder-buttons').addClass('hidden', mkStdDelay)
    $('#new-text-q-form').removeClass('hidden', mkStdDelay)

  #save q
  $('#save-new-text-q').click ->
    $newTextQ = $('#new-text-q').val()
    $pollId = currentPollId
    newQDetails = {details: {poll_id: $pollId, question_text: $newTextQ}}
    console.log newQDetails
    $.post '/projects/'+currentProjectId+'/polls/'+currentPollId+'/text_questions', (newQDetails), (successData) ->
      # alert "Just Saved " + successData.question_text
      console.log successData
      $('#new-text-q').val("")
      $('#new-text-q-form').addClass('hidden', mkStdDelay)
      $('#poll-builder-buttons').removeClass('hidden', mkStdDelay)
      populatePollSelected(currentPollId)

  #cancel q
  $('#cancel-new-text-q').click ->
    alert "should dissapear"
    $('#new-text-q').val("")
    $('#new-text-q-form').addClass('hidden', mkStdDelay)
    $('#poll-builder-buttons').removeClass('hidden', mkStdDelay)




  # Key Use Case:  SELECT A POLL and GET QUESTIONS
  # =====================================================
  # # When a poll - to be populated in the future - is clicked get ID and get more details
  $('#all-project-polls').on "click", "button", ->
    currentPollId = $(this).attr('id')
    populatePollSelected(currentPollId)


  #if visitor and not already completed, have a nice fat button prompting to fill out

  # =====================================================
  # =====================================================
  # =====================================================


  # Key Use Case:  SUBMIT RESPONSES
  # =====================================================

  $('#save-resp').click ->
    # make each text area individually addressable
    # build hash
    # currentPollId
    # currentUserId
    # for thisResponse in
    showMikeNow = $('#new-response').serializeObject()
    alert showMikeNow
    console.log showMikeNow

  $('#cancel-resp').click ->
    # just blank fields and cancel




# JST['views/whatever']({id: "4", })


  # =====================================================
  # =====================================================
  # =====================================================



