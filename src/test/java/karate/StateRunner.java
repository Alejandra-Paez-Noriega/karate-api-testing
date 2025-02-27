package karate;

import com.intuit.karate.junit5.Karate;

class StateRunner {
    
    @Karate.Test
    Karate testState() {
        return Karate.run("State").relativeTo(getClass());
    }
}
