@IsTest
public class MockProvider implements System.StubProvider {
    private Map<String, StubResponse> responseByMethodName = new Map<String, StubResponse>();
    private Object stub;

    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, Type returnType,
            List<Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs) {
        StubResponse sr = responseByMethodName.get(stubbedMethodName);
        if(sr.throwException) {
            throw sr.exceptionToThrow;
        } else {
            if(returnType == Type.forName('void')) {
                return null;
            }
            return sr.response;
        }
    }

    public MockProvider(Type classToMock) {
        stub = Test.createStub(classToMock, this);
    }

    public MockProvider returnFor(String methodName, Object response) {
        StubResponse sr = new StubResponse(response);
        this.responseByMethodName.put(methodName, sr);
        return this;
    }

    public MockProvider throwFor(String methodName, Exception ex) {
        StubResponse sr = new StubResponse(ex);
        this.responseByMethodName.put(methodName, sr);
        return this;
    }

    public Object getStub() {
        return this.stub;
    }

    private class StubResponse {
        Exception exceptionToThrow;
        Object response;
        Boolean throwException;

        public StubResponse(Object response) {
            this.exceptionToThrow = null;
            this.response = response;
            this.throwException = false;
        }

        public StubResponse(Exception ex) {
            this.exceptionToThrow = ex;
            this.response = null;
            this.throwException = true;
        }
    }

}