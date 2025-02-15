(define (problem problem1)
  (:domain emergency-services-logistics)

  (:objects
    r1 - robotic_agent
    l1 l2 l3 - location
    b1 b2 b3 b4 b5 - box
    p1 p2 - person
  )
  

  (:init
  
    ; Initial locations of robotic agent and boxes
    (at_robot_loc r1 depot)
    (at_box_loc b1 depot)
    (at_content_loc food depot)
    (at_content_loc tools depot)
    (at_content_loc medicine depot)
    

    ; Contents are initially at the depot (l1)
    
    ; People and their initial locations
    (at_person_loc p1 l2)
    (at_person_loc p2 l3)

    ; Initial state of boxes (empty)

    (content_needed p1 food)
    (content_needed p2 tools)
    (content_needed p1 medicine)
    (content_needed p1 tools)

    ; Add more needs for other persons if required

    ; Loaded state of robotic agent
    (empty b1)

    (empty_robot r1)
   
  )

  ; Goal state: Ensure that certain people have certain contents
  (:goal
    (and
      ; Assign content to persons as per their needs
        (not (content_needed p1 food))
        (not (content_needed p2 tools))
        (not (content_needed p1 tools))
        (not (content_needed p1 medicine))

    )
  )
)