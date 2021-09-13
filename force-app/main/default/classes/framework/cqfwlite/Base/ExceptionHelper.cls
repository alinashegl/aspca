/**
 * 
 * Class Description
 *
 * @author barne
 * @version 1.0.0
 */

public without sharing class ExceptionHelper {
    public static String Format(Exception ex) {
        return ex.getTypeName() + '\n'
                + ex.getLineNumber() + '\n'
                + ex.getMessage();
    }

    public static String FormatVerbose(Exception ex) {
        return ex.getTypeName() + '\n'
                + ex.getLineNumber() + '\n'
                + ex.getMessage() + '\n'
                + ex.getStackTraceString();
    }
}