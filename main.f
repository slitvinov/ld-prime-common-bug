      subroutine fill_big
      common /scruz/ x(20000)
c     x(4096) = 0 survives
      x(20000) = 0.0
      end
      
      program p
      call s1
      call fill_big
      write(6,*) 'survived'
      end
