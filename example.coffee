app = angular.module 'app', ['ngGrid']

app.controller 'MyCtrl', ($scope, $timeout, $http) ->
    
    $scope.mySelections = []
    $scope.myData = []

    pushIt = ->
        $scope.myData.push {"engine":"Webkit","browser":"Safari 3.0","platform":"OSX.4+","version":522.1,"grade":"A", "date": new Date()}
        # $scope.myData.shift()
        $timeout pushIt, 200
    pushIt()

    $scope.filterOptions =
        filterText: ''
        useExternalFilter: true

    $scope.totalServerItems = 0

    $scope.pagingOptions =
        pageSizes: [20, 100, 500, 2500]
        pageSize: 20
        currentPage: 1

    $scope.setPagingData = (data, page, pageSize) ->
        pagedData = data.slice (page - 1) * pageSize, page * pageSize
        $scope.myData = pagedData
        $scope.totalServerItems = data.length


    $scope.getPagedDataAsync = (pageSize, page, searchText) ->
        if searchText
            ft = searchText.toLowerCase()
            $http.get('/largeLoad.json').success((largeLoad) ->
                data = largeLoad.filter((item) ->
                    return JSON.stringify(item).toLowerCase().indexOf(ft) != -1
                )
                $scope.setPagingData data, page, pageSize
            )
        else
            $http.get('/largeLoad.json').success((largeLoad) ->
                $scope.setPagingData largeLoad, page, pageSize
            )

    $scope.getPagedDataAsync $scope.pagingOptions.pageSize, $scope.pagingOptions.currentPage

    $scope.$watch 'pagingOptions', (newVal, oldVal) ->
        $scope.getPagedDataAsync $scope.pagingOptions.pageSize, $scope.pagingOptions.currentPage, $scope.filterOptions.filterText

    , true

    $scope.$watch 'filterOptions', (newVal, oldVal) ->
        $scope.getPagedDataAsync $scope.pagingOptions.pageSize, $scope.pagingOptions.currentPage, $scope.filterOptions.filterText
    , true

    $scope.gridOptions =
        data: 'myData'
        columnDefs: [
                field: 'engine'
                displayName: 'Engine'
            ,
                field: 'browser'
                displayName: 'Browser'
            ,
                field: 'platform'
                displayName: 'Platform'
            ,
                field: 'version'
                displayName: 'Version'
                # cellTemplate: 'cellTemplate.html'
            ,
                field: 'grade'
                displayName: 'Grade'
            ,
                field: 'date'
                displayName: 'Date'
        ]
        # showGroupPanel: true
        # enableCellSelection: true
        # enableCellEditOnFocus: true
        # enablePinning: true
        enablePaging: true
        # enableRowSelection: false
        showFooter: true
        # selectedItems: $scope.mySelections
        totalServerItems: 'totalServerItems'
        pagingOptions: $scope.pagingOptions
        filterOptions: $scope.filterOptions