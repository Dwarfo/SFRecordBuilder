@isTest
public class MockUtil {
    private static Map<Type, MockProvider> mockProviderByType = new Map<Type, MockProvider>();

    public static void addStub(Type typeToMock) {
        mockProviderByType.put(typeToMock, new MockProvider(typeToMock));
    }

    public static MockProvider getStubProvider(Type stubbedClass) {
        MockProvider provider = mockProviderByType.get(stubbedClass);
        return provider;
    }

}