(define (problem eslp)
  (:domain emergency-services-logistics)

  (:objects
    r1 - robotic_agent
    l1 l2 l3 - location
    b1 b2 b3 b4 b5 b6 - box
    p1 p2 - person
    ca1 - carrier
    f2 m2 t2 - content
  )
  

  (:init


    (= (box_on_carrier ca1) 0)
    (= (capacity_carrier ca1 ) 4)
    (= (content_on_carrier ca1) 0)
    (at_robot_loc r1 d1)
    (at_box_loc b1 d1)
    (at_box_loc b2 d1)
    (at_box_loc b3 d1)
    (at_box_loc b4 d1)
    (at_box_loc b5 d1)
    (at_box_loc b6 d1)
    (at_content_loc f1 d1)
    (at_content_loc t1 d1)
    (at_content_loc m1 d1)
    (at_content_loc f2 d1)
    (at_content_loc t2 d1)
    (at_content_loc m2 d1)
    (at_carrier_loc ca1 d1)

    (at_person_loc p1 l2)
    (at_person_loc p2 l3)
    
    
    (loaded_carrier r1 ca1)


    (content_needed p1 f1)
    (content_needed p1 m1)
    (content_needed p1 t1)
    (content_needed p2 f2)
    (content_needed p2 m2)
    (content_needed p2 t2)
    
    (empty b1)
    (empty b2)
    (empty b3)
    (empty b4)
    (empty b5)
    (empty b6)
   
  )

  ; Goal state: Ensure that certain people have certain contents
  (:goal
    (and
      ; Assign content to persons as per their needs
       ;(and (empty b2)
    ;         (not (empty b1))
        ;)
        ;(content_in_box f1 b1)
        ;(at_robot_loc r1 l2)
        (non_content_needed p1 f1)
        (non_content_needed p1 t1)
        (non_content_needed p2 t2)
        (non_content_needed p2 f2)
        (non_content_needed p1 m1)
        (non_content_needed p2 m2)
        ;(not (content_needed p2 tools))
        ;
        ;(loaded ca1 b1)
      ;(have p1 b1)
      ;(have p2 b1)
      ;(have p1 b1)
      ;(have p2 b1)
      ;(have p1 b1)
      ; Add more content assignments for other persons if required
    )
  )

  (:metric minimize (total-time))
)
