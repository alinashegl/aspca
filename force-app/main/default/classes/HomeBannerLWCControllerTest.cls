@isTest
public class HomeBannerLWCControllerTest {

    @isTest
    static void testgetButtonsInfo(){
        HomeBannerLWCController.ButtonsToDisplay bd = HomeBannerLWCController.getButtonsInfo();
        System.assertNotEquals(bd, null);
    }

    @isTest 
    static void getToDoListVisibility(){
        HomeBannerLWCController.TodoListVisibility vis = HomeBannerLWCController.getToDoListVisibility();

        System.assertEquals(true, vis.mrcTodoList);
    }
}