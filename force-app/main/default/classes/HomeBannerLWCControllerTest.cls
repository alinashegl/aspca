@isTest
public class HomeBannerLWCControllerTest {

    @isTest
    static void testgetButtonsInfo(){
        HomeBannerLWCController.ButtonsToDisplay bd = HomeBannerLWCController.getButtonsInfo();
        System.assertNotEquals(bd, null);
    }
}