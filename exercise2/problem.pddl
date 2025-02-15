(define (problem problem2)
  (:domain emergency-services-logistics)

  (:objects
    r1 - robotic_agent
    l1 l2 l3 - location
    b1 b2 b3 b4 - box
    p1 p2 - person
    ca1 - carrier
  )
  

  (:init
  
  
    (empty_robot r1)

    (not (holding r1 b1))
    (not (holding r1 b2))
    (not (holding r1 b3))
    (not (holding r1 b4))

    (not (attach_carrier r1 ca1))

    (at_robot_loc r1 depot)
    (at_box_loc b1 depot)
    (at_box_loc b2 depot)
    (at_box_loc b3 depot)
    (at_box_loc b4 depot)
    (at_content_loc food depot)
    (at_content_loc tools depot)
    (at_content_loc medicine depot)
    (at_carrier_loc ca1 depot)

    (at_person_loc p1 l2)
    (at_person_loc p2 l3)

    (num_box_on_carrier ca1 zero)

    (succ zero one)
    (succ one two)
    (succ two three)
    (succ three four)

    (pred four three)
    (pred three two)
    (pred two one)
    (pred one zero)
    
    (content_needed p1 food)
    (content_needed p1 medicine)
    (content_needed p2 tools)
    
    (empty b1)
    (empty b2)
    (empty b3)
    (empty b4)
    
    (not_loaded ca1 b1)
    (not_loaded ca1 b2)
    (not_loaded ca1 b3)
    (not_loaded ca1 b4)

    (not_delivered p1 food)
    (not_delivered p1 medicine)
    (not_delivered p2 tools)

  )

  ; Goal state: Ensure that certain people have certain contents
  (:goal
    (and
      ; Assign content to persons as per their needs
        (not (content_needed p1 food))
        (not (content_needed p1 medicine))
        (not (content_needed p2 tools))
        ;(not (content_needed p2 tools))
      ; Add more content assignments for other persons if required
    )
  )
)