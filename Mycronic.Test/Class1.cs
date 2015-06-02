using Machine.Specifications;

// ReSharper disable InconsistentNaming
namespace Mycronic.Test
{
    [Tags("Delete this later")]
    [Subject("Testing MSpec")]
    public class testing_mspec_is_working
    {
        private static int ValueA;
        private static int ValueB;

        private Establish context = () =>
        {
            ValueA = 33;
            ValueB = 15;
        };

        private It should_run = () => ValueA.ShouldBeGreaterThan(ValueB);
    }

}
// ReSharper restore InconsistentNaming

