app = angular.module 'app', ['ngGrid']

app.controller 'MyCtrl', ($scope, $timeout) ->
    
    $scope.myData = []

    pushIt = ->
        $scope.myData.push {"engine":"Webkit","browser":"Safari 3.0","platform":"OSX.4+","version":522.1,"grade":"A", "date":new Date()}
        $timeout pushIt, 500
    pushIt()

    $scope.filterOptions =
        filterText: ''
        useExternalFilter: true

    $scope.totalServerItems = 0

    $scope.pagingOptions =
        pageSizes: [5, 10, 15]
        pageSize: 5
        currentPage: 1

    $scope.setPagingData = (data, page, pageSize) ->
        pagedData = data.slice (page - 1) * pageSize, page * pageSize
        $scope.myData = pagedData
        $scope.totalServerItems = data.length
        if !$scope.$$phase
            $scope.$apply()

    $scope.getPagedDataAsync = (pageSize, page, searchText) ->
        setTimeout ->
            data
            if searchText
                ft = searchText.toLowerCase()
                $http.get('largeLoad.json').success((largeLoad) ->
                    data = largeLoad.filter((item) ->
                        return JSON.stringify(item).toLowerCase().indexOf(ft) != -1
                    )
                    $scope.setPagingData data, page, pageSize
                )
        , 100

        $scope.getPagedDataAsync $scope.pagingOptions.pageSize, $scope.pagingOptions.currentPage

        $scope.$watch 'pagingOptions', (newVal, oldVal) ->
            if newVal != oldVal && newVal.currentPage != oldVal.currentPage
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
                cellTemplate: 'cellTemplate.html'
            ,
                field: 'grade'
                displayName: 'Grade'
            ,
                field: 'date'
                displayName: 'Date'
        ]
        showGroupPanel: true
        enableCellSelection: true
        enablePinning: true
        enablePaging: true
        showFooter: true