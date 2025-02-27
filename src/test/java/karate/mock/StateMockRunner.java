package karate.mock;

import com.intuit.karate.junit5.Karate;

class StateMockRunner {
    
    @Karate.Test
    Karate runMock() {
        return Karate.run("StateMock").relativeTo(getClass());
    }
}
