!< OFF test: stirling engine.

program off_test_stirling
!< OFF test: stirling engine.

use off_objects, only : simulation_object
use flap, only : command_line_interface
use penf, only : I4P

implicit none
type(simulation_object)       :: simulation          !< Simulation data.
character(len=:), allocatable :: grid_file_name      !< Grid file name.
character(len=:), allocatable :: ic_file_name        !< Initial conditions file name.
character(999)                :: inf_name            !< Input file name.
character(999)                :: outf_name           !< Output file name.
logical                       :: are_tests_passed(1) !< Result of tests check.

are_tests_passed = .false.

call cli_parse
call simulation%initialize(file_parameters=trim(adjustl(inf_name)))
! call simulation%integrate
call simulation%save_file_solution(file_name=trim(adjustl(outf_name)), metrics=.true., off=.false., vtk=.true., &
                                   n=simulation%time%n, force=.true.)

print '(A,L1)', 'Are all tests passed? ', all(are_tests_passed)

contains
  subroutine cli_parse()
  !< Build and parse test cli.
  type(command_line_interface) :: cli   !< Test command line interface.
  integer(I4P)                 :: error !< Error trapping flag.

  call cli%init(progname='off_test_stirling',   &
                authors='S. Zaghi',             &
                help='Usage: ',                 &
                examples=["off_test_stirling"], &
                epilog=new_line('a')//"all done")

  call cli%add(switch='--input',                            &
               help='input file name',                      &
               required=.false.,                            &
               def='src/tests/stirling_input/stirling.ini', &
               act='store')

  call cli%add(switch='--output',       &
               help='output file name', &
               required=.false.,        &
               def='stirling',          &
               act='store')

  call cli%parse(error=error) ; if (error/=0) stop

  call cli%get(switch='--input',  val=inf_name,  error=error) ; if (error/=0) stop
  call cli%get(switch='--output', val=outf_name, error=error) ; if (error/=0) stop
  endsubroutine cli_parse
endprogram off_test_stirling
